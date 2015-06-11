//
//  VisitorTableController.swift
//  SwiftLoginScreen
//
//  Created by Dominic on 8/06/15.
//  Copyright (c) 2015 Dominic. All rights reserved.
//

import UIKit


class VisitorTableController: UITableViewController {

    
    //@IBOutlet weak var homeButton: UIBarButtonItem!
    var jsonData:NSDictionary!
    var visitorArray:NSArray!
    
    var success:Bool = false
    var visitorIndex = 0
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(true)
        
        visitorIndex = 0
        //Currently disabled as i am testing the tabcontroller
        //Setting home button action
        //homeButton.action = ("returnToHome:")
        
        
        
        //Moving the GET request for visitors from ViewController to this tableController
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let token:NSString = prefs.valueForKey("TOKEN") as NSString
        var url:NSURL = NSURL(string: "https://swipedon.ninja/api/visitors")!
        
        var request:NSMutableURLRequest = NSMutableURLRequest (URL: url)
        request.HTTPMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "VB-Auth-Token")
        
        
        var response:NSURLResponse?
        var responseError:NSError?
        
        //execute request
        let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
        
        var error: NSError?
        
        jsonData = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        
        //Bit of data manipulation
        success = jsonData.valueForKey("success") as Bool
        
        visitorArray = jsonData.valueForKey("list") as NSArray
        
        
        
        NSLog ("Visitors GET output: %@", NSString(data:urlData!, encoding:NSUTF8StringEncoding)!)
        NSLog ("Length of visitorArray = %1d", visitorArray.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (success){
            NSLog("Successful entry!")
            
            return (jsonData.valueForKey("totalCount") as NSInteger)
        } else {
            NSLog("Unsuccessful!")
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        //cell.textLabel!.text = ("Visitor \(visitorIndex)")
        
        let visitor:NSDictionary = visitorArray[visitorIndex] as NSDictionary
        
        
        NSLog("VisitorIndex = \(visitorIndex) has the information \n\(visitorArray[visitorIndex])")
        let name:NSString = (visitor.valueForKey("visitor") as NSDictionary).valueForKey("full_name") as NSString
        
        cell.textLabel!.text = name
        visitorIndex++
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // Old UINavigationButton method that was used before tab controller
    /*
    func returnToHome(sender:UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion:nil)
        
    }
*/
}
