//
//  TableViewController.swift
//  NexmoToDoList
//
//  Created by Sidharth Sharma on 10/1/15.
//  Copyright © 2015 Sidharth Sharma. All rights reserved.
//

import Foundation
import Parse
import UIKit

class TableViewController:UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "cell"
    var todoArray: [String] = []
    var currentUser:PFUser!
    
    @IBOutlet weak var toDoTable: UITableView!

    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender:self)
    }
    
    override func viewDidAppear(animated: Bool) {
        retrieveToDos()
    }
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTable.delegate = self
        toDoTable.dataSource = self
        print(PFUser.currentUser()?.username)
    }
    
    func retrieveToDos() {
        let query:PFQuery = PFQuery(className: "ToDo")
        let currentUser = query.whereKey("user", equalTo: PFUser.currentUser()!)
        currentUser.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if objects != nil {
            for object in objects! {
                let todo:String? = (object)["todoItem"] as? String
                if todo != nil {
                    self.todoArray.append(todo!)
                        print("todo")
                    }
                }
            }
            self.toDoTable.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = todoArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //looks for editing style by user sliding left on a cell on a table
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let query = PFQuery(className:"ToDo")
            query.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if (error != nil || object == nil) {
                    print("The request failed.")
                }
                else {
                    object? .deleteInBackgroundWithBlock( { (success, err) -> Void in
                        if error == nil {
                            if success {
                                self.todoArray.removeAtIndex(indexPath.row)
                                print("Deleted Successfully")
                                self.toDoTable.reloadData()
                            }
                        } else {
                            print("Error : \(err?.localizedDescription) \(err?.userInfo)")
                        }
                    })
                }
            })
            toDoTable.reloadData()
        }
    }
}