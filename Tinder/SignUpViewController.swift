//
//  SignUpViewController.swift
//  Tinder
//
//  Created by Nick on 9/2/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class SignUpViewController: UIViewController {
    
    var user = PFUser.currentUser()

    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBAction func signUp(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        var FBSession = PFFacebookUtils.session()
        var accessToken = FBSDKAccessToken.currentAccessToken()
        var tokenString = accessToken.tokenString
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+tokenString)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let image = UIImage(data: data)
            self.profilePic.image = image
            
            self.user?.setObject(data, forKey: "ProfilePic")
            self.user?.save()
            
            //finding gender
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, gender"])
            graphRequest.startWithCompletionHandler({
                connection, result, error in
                
                println(result)
                
                var gend = result["gender"]
                self.user?.setObject(gend, forKey: "gender")
                
            })
            
            
        })
        
        /* Making sure pic will load without fb
        var user = PFUser.currentUser()
        let image = UIImage(data: user?.objectForKey("ProfilePic") as! NSData)
        profilePic.image = image
        */
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
