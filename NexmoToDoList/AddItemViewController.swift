//
//  AddItemViewController.swift
//  NexmoToDoList
//
//  Created by Sidharth Sharma on 10/1/15.
//  Copyright © 2015 Sidharth Sharma. All rights reserved.
//

import Foundation
import Parse
import UIKit
import VerifyIosSdk

class AddItemViewController:UIViewController {
    
    @IBOutlet weak var item: UITextField!
    @IBOutlet weak var pinCode: UITextField!
    
    @IBAction func addButton(sender: AnyObject) {
        VerifyClient.checkPinCode(pinCode.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VerifyClient.getVerifiedUser(countryCode: "US", phoneNumber: PFUser.currentUser()!["phoneNumber"].description,
            onVerifyInProgress: {
            }, onUserVerified: {
                let toDoItem = PFObject(className:"ToDo")
                toDoItem["user"] = PFUser.currentUser()!
                if self.item.text!.isEmpty == false {
                    toDoItem["todoItem"] = self.item.text
                    toDoItem.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        print("Object has been saved.")
                        self.performSegueWithIdentifier("addToDoItem", sender:self)
                    }
                }
                else {
                    let alert = UIAlertView()
                    alert.title = "Invalid Entry"
                    alert.message = "Make sure to add a To-Do item."
                    alert.addButtonWithTitle("Back")
                    alert.show()
                    self.performSegueWithIdentifier("invalidEntry", sender:self)
                }
            },
            onError: { verifyError in
                
        })

    }
}
