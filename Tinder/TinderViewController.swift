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
    
    var xFromCenter: CGFloat = 0 //for dragging
    
    var usernames = [String]()
    var userImages = [NSData]()
    var currentUser = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        PFGeoPoint.geoPointForCurrentLocationInBackground { geoPoint, error in
            
            if error == nil {
                println(geoPoint!)
                
                var user = PFUser.currentUser()
                user?.setObject(geoPoint!, forKey: "location")
                
                /* Had to remove these two for some unknown bug. resume as gender1 and gender2 below
                query?.whereKey("username", notEqualTo: PFUser.currentUser()!.username!) //added this later
                query?.whereKey("InterestedIn", equalTo: PFUser.currentUser()!.objectForKey("gender")!)
                */
                
                //copied from Parse Geo Queries
                var query = PFUser.query()
                query!.whereKey("location", nearGeoPoint:geoPoint!)
                query!.limit = 10
                query?.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    
                    for user in users! {
                        
                        var gender1 = user.objectForKey("gender") as! NSString
                        var gender2 = "female" //for testing purposes //PFUser.currentUser()?.objectForKey("InterestedIn") as? NSString
                        
                        if gender1 == gender2 && PFUser.currentUser()?.username != user.username {
                            self.usernames.append(user.objectForKey("username") as! String)
                            self.userImages.append(user.objectForKey("ProfilePic") as! NSData)
                        }
                        
                    }
                    
                    
                    //for dragging
                    var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                    userImage.image = UIImage(data: self.userImages[0]) //UIImage(named: "placeholder.jpg") //replace with actual image
                    userImage.contentMode = UIViewContentMode.ScaleAspectFit
                    self.view.addSubview(userImage)
                    
                    var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                    userImage.addGestureRecognizer(gesture)
                    
                    userImage.userInteractionEnabled = true
                    
                    
                })
                
                user?.save()
            }
            
            if error != nil {
                println("error")
            }
        }
        
        
        //Adding people code only used once to load Parse with users
        /*
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
        */
        
        /*
        addPerson("http://www.adweek.com/fishbowlny/files/2013/06/Screen-Shot-2013-06-06-at-1.34.55-PM.png")
        addPerson("http://images.mentalfloss.com/sites/default/files/styles/insert_main_wide_image/public/90808171.jpg")
        addPerson("http://www.who2.com/sites/default/files/blog/depphead-thumb-420x630-945.jpg")
        addPerson("http://cdn2.belfasttelegraph.co.uk/migration_catalog/article29037675.ece/32da5/ALTERNATES/h342/Films%208-1.jpg")
        addPerson("http://images.essentialbaby.com.au/2012/06/26/3405699/gal_aniston-496x620.jpg")
        addPerson("http://static.gamesradar.com/images/totalfilm/-/-to-sexy-star.jpg")
        addPerson("http://i.dailymail.co.uk/i/pix/2014/01/02/article-2532555-1A62A44C00000578-298_306x423.jpg")
        */

    }
    
    
    
    func wasDragged(gesture: UIPanGestureRecognizer){
        
        let translation = gesture.translationInView(self.view)
        var label = gesture.view!
        
        xFromCenter += translation.x
        
        var scale = min(100 / abs(xFromCenter), 1)
        
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        if label.center.x < 100 {
            println("Not Chosen")
        } else if label.center.x > self.view.bounds.width - 100 {
            println("Chosen")
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            self.currentUser++
            
            label.removeFromSuperview()
            
            if self.currentUser < self.userImages.count {
            
                var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                userImage.image = UIImage(data: self.userImages[self.currentUser]) //userImage.image = UIImage(named: "placeholder.jpg") //replace this
                userImage.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(userImage)
                
                var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                userImage.addGestureRecognizer(gesture)
                
                userImage.userInteractionEnabled = true
                
                xFromCenter = 0
                
            } else {
                println("No more users")
            }
        }
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
