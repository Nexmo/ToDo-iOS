//
//  LoginViewController.swift
//  NexmoToDoList
//
//  Created by Sidharth Sharma on 9/20/15.
//  Copyright (c) 2015 Sidharth Sharma. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginViewController: UIViewController  {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    var currentUser:PFUser!
    
    @IBAction func loginButton(sender: AnyObject) {
        login()
    }
    
    func login() {
        PFUser.logInWithUsernameInBackground(userName.text!, password:password.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.currentUser  = PFUser.currentUser()
                print("Success")
                // Do stuff after successful login
                self.performSegueWithIdentifier("table", sender:self)
            } else {
                // The login failed. Check error to see why.
                let alert = UIAlertView()
                alert.title = "Login Error"
                alert.message = "Please re-enter your credentials or sign up below."
                alert.addButtonWithTitle("Back")
                alert.show()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PFUser.logOut()
        print(PFUser.currentUser()?.username)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "table") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let loggedInVC = segue.destinationViewController as! TableViewController;
            loggedInVC.currentUser = self.currentUser
        }
    }
}