//
//  TableVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("seguePosting", sender: nil)
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func refreshButtonPressed(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("id")
        
        return cell!
    }
}
