//
//  VerifyLoginViewController.swift
//  NexmoToDoList
//
//  Created by Sidharth Sharma on 12/8/15.
//  Copyright © 2015 Sidharth Sharma. All rights reserved.
//

import Foundation
import UIKit
import VerifyIosSdk
import Parse

class VerifyLoginViewController:UIViewController {
    
    var currentUser = PFUser()
    
    @IBOutlet weak var pinCode: UITextField!
    
    @IBAction func verifyButton(sender: UIButton) {
        VerifyClient.checkPinCode(pinCode.text!)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.performSegueWithIdentifier("error", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VerifyClient.getVerifiedUser(countryCode: "US", phoneNumber: currentUser["phoneNumber"].description,
            onVerifyInProgress: {
                print("Verification Begun")
            }, onUserVerified: {
                self.performSegueWithIdentifier("verifiedLogin", sender:self)
        }, onError: { verifyError in
            self.performSegueWithIdentifier("error", sender: self)
        })
    }
    
}