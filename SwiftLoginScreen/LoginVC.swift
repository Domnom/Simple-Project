//
//  LoginVC.swift
//  SwiftLoginScreen
//
//  Created by Dominic on 29/05/15.
//  Copyright (c) 2015 Dominic. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var txtPin: UITextField!
    //@IBOutlet weak var txtUsername: UITextField!
    //@IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signinTapped(sender: UIButton) {
        // Authentication Code
//        var username:NSString = txtUsername.text
//        var password:NSString = txtPassword.text
        var pin:NSString = txtPin.text
        
    //No input
        if (pin.isEqualToString("")) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in failed!"
            alertView.message = "Please enter a Pin"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else {
            
            var post:NSString = "{'pin':'\(pin)'}"
            
            NSLog("PostData: %@", post);
            
            var url:NSURL = NSURL (string: "https://swipedon.ninja/api/login")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String(post.length)
            
            var request:NSMutableURLRequest = NSMutableURLRequest (URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("applicaton/json", forHTTPHeaderField: "Accept")
            
            var responseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
            
            if (urlData != nil) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %1d", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
                    
                    let success:NSInteger = jsonData.valueForKey("success") as NSInteger
                    
                    NSLog("Success: %1d", success);
                    
                    if (success == 1) {
                        NSLog("Login Success!");
                        
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        //prefs.setObject(username, forKey: "USERNAME")
                        prefs.setObject(pin, forKey:"PIN")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        NSLog("Okay here")
                        self.dismissViewControllerAnimated(true, completion:nil)
                        NSLog("Still Okay")
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("Ok")
                        alertView.show()
                    }
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in failed!"
                    alertView.message = "Connection failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in failed!"
                alertView.message = "Connection failure"
                if let error = responseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
