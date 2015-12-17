//
//  SignupViewController.swift
//  NexmoToDoList
//
//  Created by Sidharth Sharma on 10/1/15.
//  Copyright © 2015 Sidharth Sharma. All rights reserved.
//

import Foundation
import UIKit
import Parse
import VerifyIosSdk

class SignupViewController:UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBAction func signupButton(sender: AnyObject) {
        signup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(PFUser.currentUser()?.username)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "verify") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let verifyVC = segue.destinationViewController as! VerifyViewController;
            verifyVC.phoneNumber = phoneNumber.text
            verifyVC.userName = userName.text
            verifyVC.passWord = password.text
        }
    }
    
    func signup() {
        let alert = UIAlertView()
        
        if (self.phoneNumber.text!.isEmpty || self.password.text!.isEmpty || self.userName.text!.isEmpty) {
            alert.title = "Invalid Credentials"
            alert.message = "Make sure to fill out all the required fields."
            alert.addButtonWithTitle("Back")
            alert.show()
        }
        else {
            let query = PFQuery(className: "_User")
            query.whereKey("phoneNumber", equalTo: phoneNumber.text!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) in
                if error == nil {
                    if (objects!.count > 0){
                        alert.title = "Phone Number Error"
                        alert.message = "This phone number is associated with another account."
                        alert.addButtonWithTitle("Back")
                        alert.show()
                    }
                    else {
                        self.performSegueWithIdentifier("verify", sender:self)
                    }
                }
            }
        }
    }
}