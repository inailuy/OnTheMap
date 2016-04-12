//
//  TableVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class TableVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        tableView.alpha = 0.5
        startAnimatingIndicator()
        NetworkArchitecture.sharedInstance.getStudentLocations() {
            () in
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.alpha = 1.0
                self.stopAnimatingIndicator()
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("seguePosting", sender: nil)
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        performLogout()
        dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func refreshButtonPressed(sender: AnyObject) {
        fetchData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkArchitecture.sharedInstance.studentLocationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let studentLocationModel = NetworkArchitecture.sharedInstance.studentLocationArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("id")
        
        let nameLabel = cell?.viewWithTag(100) as! UILabel
        let urlLabel = cell?.viewWithTag(101) as! UILabel
        nameLabel.text = studentLocationModel.firstName + " " + studentLocationModel.lastName
        urlLabel.text = studentLocationModel.mediaURL
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentLocationModel = NetworkArchitecture.sharedInstance.studentLocationArray[indexPath.row]
        let url = NSURL(string: studentLocationModel.mediaURL)
        if url != nil {
            UIApplication.sharedApplication().openURL(url!)
        } else {
            handleErrors("Link is not a proper URL")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
