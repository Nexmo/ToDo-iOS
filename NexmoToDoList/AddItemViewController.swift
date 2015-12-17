//
//  AddItemViewController.swift
//  NexmoToDoList
//
//  Created by Sidharth Sharma on 10/1/15.
//  Copyright © 2015 Sidharth Sharma. All rights reserved.
//

import Foundation
import Parse

class AddItemViewController:UIViewController {
    var currentUser:PFUser!
    
    @IBOutlet weak var item: UITextField!
    @IBAction func addButton(sender: AnyObject) {
   
        let toDoItem = PFObject(className:"ToDo")
        toDoItem["user"] = PFUser.currentUser()!
    
        if item.text!.isEmpty == false {
            toDoItem["todoItem"] = item.text
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
