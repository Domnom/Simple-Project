//
//  ViewController.swift
//  SwiftLoginScreen
//
//  Created by Dominic on 29/05/15.
//  Copyright (c) 2015 Dominic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    var testVar = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        
        if (isLoggedIn != 1) {
            //do nothing, move to viewDidAppear()
            
        } else {
            
            let token:NSString = prefs.valueForKey("TOKEN") as NSString
            var url:NSURL = NSURL(string: "https://swipedon.ninja/api/visitors")!
            
            var request:NSMutableURLRequest = NSMutableURLRequest (URL: url)
            request.HTTPMethod = "GET"
            request.setValue(token, forHTTPHeaderField: "VB-Auth-Token")
            
            var response:NSURLResponse?
            var responseError:NSError?
            
            //execute request
            let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
            
            NSLog ("Visitors GET output: %@", NSString(data:urlData!, encoding:NSUTF8StringEncoding)!)
            
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("PIN") as NSString
            NSLog ("The token string is: %@", (prefs.valueForKey("TOKEN") as NSString))
            
        }
        
        
    }


    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}

