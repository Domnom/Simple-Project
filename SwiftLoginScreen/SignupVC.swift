//
//  SignupVC.swift
//  SwiftLoginScreen
//
//  Created by Dominic on 29/05/15.
//  Copyright (c) 2015 Dominic. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupTapped(sender: UIButton) {
        var username:NSString = txtUsername.text as NSString
        var password:NSString = txtPassword.text as NSString
        var confirm_password:NSString = txtConfirmPassword.text as NSString
        
    //User has not entered a valid username or password - present a popup alert
        if (username.isEqualToString("") || password.isEqualToString("")) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up failed!"
            alertView.message = "Please enter a Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
    //password and confirm passwords are not equivalent
        } else if (!password.isEqual(confirm_password)) {
        
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up failed!"
            alertView.message = "Passwords do not match!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else {
            
            var post:NSString = "username=\(username)&password=\(password)&c_password=\(confirm_password)"
            
            NSLog("PostData: %@", post);
            
            //Currently set to the tutorial URL - TO CHANGE
            var url:NSURL = NSURL(string: "https://dipinkrishna.com/jsonsignup.php")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String(post.length)
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var responseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
            
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
                        NSLog("Sign up: Success!");
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as NSString
                            
                        } else {
                            error_msg = "Unknown Error"
                            
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign up failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("Ok")
                        alertView.show()
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign up failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("Ok")
                    alertView.show()
                }
                
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in failed!"
                alertView.message = "Connection Failure"
                
                if let error = responseError {
                    alertView.message = error.localizedDescription
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("Ok")
                alertView.show()
            }
            
        }
    }
    

    @IBAction func gotoLogin(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
