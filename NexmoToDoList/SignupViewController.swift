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

class SignupViewController:UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func signupButton(sender: AnyObject) {
        signup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(PFUser.currentUser()?.username)
    }
    
    func signup() {
        let user = PFUser()
        user.username = userName.text
        user.password = password.text
        
        let alert = UIAlertView()
        
        if ( self.password.text!.isEmpty || self.userName.text!.isEmpty) {
            alert.title = "Invalid Credentials"
            alert.message = "Make sure to fill out all the required fields."
            alert.addButtonWithTitle("Back")
            alert.show()
        }
        else {
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
                    self.performSegueWithIdentifier("signedUp", sender:self)
                }
            }
        }
    }
}

