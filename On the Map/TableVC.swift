//
//  TableVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
class TableVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    // MARK: Button Actions
    @IBAction func postButtonPressed(sender: AnyObject) {
        NetworkArchitecture.sharedInstance.getStudentLocation()
        performSegueWithIdentifier("seguePosting", sender: nil)
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        performLogout()
    }

    @IBAction func refreshButtonPressed(sender: AnyObject) {
        fetchData()
    }
    // MARK: UITableView Delegate/DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkArchitecture.sharedInstance.studentLocationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let studentLocationModel = NetworkArchitecture.sharedInstance.studentLocationArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("id")
        
        let nameLabel = cell?.viewWithTag(100) as! UILabel
        let urlLabel = cell?.viewWithTag(101) as! UILabel
        nameLabel.text = studentLocationModel.fullName()
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
    //MARK: Misc
    func fetchData() {
        tableView.alpha = 0.4
        startAnimatingIndicator()
        NetworkArchitecture.sharedInstance.getStudentLocations({ (errorString: String?) in
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.alpha = 1.0
                self.stopAnimatingIndicator()
                if errorString == nil {
                    self.tableView.reloadData()
                } else {
                    self.handleErrors(errorString!)
                }
            })
        })
    }
}