//
//  TinderViewController.swift
//  Tinder
//
//  Created by Nick on 9/3/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit
import Parse

class TinderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        PFGeoPoint.geoPointForCurrentLocationInBackground { geoPoint, error in
            
            if error == nil {
                println(geoPoint!)
                
                var user = PFUser.currentUser()
                user?.setObject(geoPoint!, forKey: "location")
                user?.save()
            }
            
            if error != nil {
                println("error")
            }
        }
        
        var i = 20
        
        func addPerson(urlString:String) {
            
            var newUser = PFUser()
            
            let url = NSURL(string: urlString)
            
            let urlRequest = NSURLRequest(URL: url!)
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                response, data, error in
                
                newUser.setObject(data, forKey: "ProfilePic")
                newUser.setObject("female", forKey: "gender")
                
                
                
                //for new users
                var lat = Double(50 + i)
                var lon = Double(1 + i)
                
                i = i+10
                
                var location = PFGeoPoint(latitude: lat, longitude: lon)
                
                newUser.setObject(location, forKey: "location")
                
                newUser.username = "\(i)"
                newUser.password = "password"
                newUser.signUp()
                
                
            })
            
            
            
        }
        
        addPerson("http://www.adweek.com/fishbowlny/files/2013/06/Screen-Shot-2013-06-06-at-1.34.55-PM.png")
        addPerson("http://images.mentalfloss.com/sites/default/files/styles/insert_main_wide_image/public/90808171.jpg")
        addPerson("http://www.who2.com/sites/default/files/blog/depphead-thumb-420x630-945.jpg")
        addPerson("http://cdn2.belfasttelegraph.co.uk/migration_catalog/article29037675.ece/32da5/ALTERNATES/h342/Films%208-1.jpg")
        addPerson("http://images.essentialbaby.com.au/2012/06/26/3405699/gal_aniston-496x620.jpg")
        addPerson("http://static.gamesradar.com/images/totalfilm/-/-to-sexy-star.jpg")
        addPerson("http://i.dailymail.co.uk/i/pix/2014/01/02/article-2532555-1A62A44C00000578-298_306x423.jpg")
        
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
