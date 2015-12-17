//
//  VerifyViewController.swift
//  NexmoToDoList
//
//  Created by Sidharth Sharma on 10/1/15.
//  Copyright © 2015 Sidharth Sharma. All rights reserved.
//


import Foundation
import Parse
import UIKit
import VerifyIosSdk

class VerifyViewController:UIViewController {
    @IBOutlet weak var pinCode: UITextField!

    @IBAction func verifyButton(sender: AnyObject) {
            print(VerifyClient.checkPinCode(pinCode.text!))
    }
    
    var phoneNumber:String!
    var userName:String!
    var passWord:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VerifyClient.getVerifiedUser(countryCode: "US", phoneNumber: phoneNumber, onVerifyInProgress: {
            }, onUserVerified: {
                let user = PFUser()
                user.username = self.userName
                user.password = self.passWord
                user["phoneNumber"] = self.phoneNumber
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo["error"] as? NSString
                        let alert = UIAlertView()
                        alert.title = "Sign Up Error"
                        alert.message = errorString?.capitalizedString
                        alert.addButtonWithTitle("Back")
                        alert.show()
                    }
                    else {
                        self.performSegueWithIdentifier("verifiedUser", sender:self)
                    }
                }
            }, onError: { verifyError in
                switch (verifyError) {
                    case .INVALID_NUMBER:
                        UIAlertView(title: "Invalid Phone Number", message: "The phone number you entered is invalid.", delegate: nil, cancelButtonTitle: "Oh, gosh darnit!").show()
                    case .INVALID_PIN_CODE:
                        UIAlertView(title: "Wrong Pin Code", message: "The pin code you entered is invalid.", delegate: nil, cancelButtonTitle: "Whoops!").show()
                    case .INVALID_CODE_TOO_MANY_TIMES:
                        UIAlertView(title: "Invalid code too many times", message: "You have entered an invalid code too many times, verification process has stopped..", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .INVALID_CREDENTIALS:
                    UIAlertView(title: "Invalid Credentials", message: "Having trouble connecting to your account. Please check your app key and secret.", delegate: nil, cancelButtonTitle: "Sure thing.").show()
                    case .USER_EXPIRED:
                    UIAlertView(title: "User Expired", message: "Verification for current use expired (usually due to timeout), please start verification again.", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .USER_BLACKLISTED:
                    UIAlertView(title: "User Blacklisted", message: "Unable to verify this user due to blacklisting!", delegate: nil, cancelButtonTitle: "Whoa...").show()
                    case .QUOTA_EXCEEDED:
                        UIAlertView(title: "Quota Exceeded", message: "You do not have enough credit to complete the verification.", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .SDK_REVISION_NOT_SUPPORTED:
                        UIAlertView(title: "SDK Revision too old", message: "This SDK revision is not supported anymore!", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .OS_NOT_SUPPORTED:
                        UIAlertView(title: "iOS version not supported", message: "This iOS version is not supported", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .VERIFICATION_ALREADY_STARTED:
                        UIAlertView(title: "Verification already started", message: "A verification is already in progress!", delegate: nil, cancelButtonTitle: "Oh, okay").show()
                    default: break
                }
        })
    }
}
