//
//  ViewController.swift
//  Tinder
//
//  Created by Nick on 8/28/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class ViewController: UIViewController {

    @IBOutlet weak var loginCancelledLabel: UILabel!
    
    @IBAction func signin(sender: AnyObject) {
        
        var permissions = ["public_profile"]
        self.loginCancelledLabel.alpha = 0
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    
                    self.performSegueWithIdentifier("signUp", sender: self)
                    
                } else {
                    println("User logged in through Facebook!")
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
                self.loginCancelledLabel.alpha = 1
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil {
            println("User loggin in")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

