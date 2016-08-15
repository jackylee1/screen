//
//  LoginViewController.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-04.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    let facebook = FacebookHandler.sharedInstance
    let managedObjectContext = FacebookHandler.sharedInstance.managedObjectContext
    var defaults = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaults.setValue("0", forKey: "AWSUserID")
        
        let hasCurrentToken = FacebookHandler.sharedInstance.facebookToken()
        
        if hasCurrentToken {
            facebook.returnUserData()
        } else {
            loginButton.readPermissions = ["public_profile", "email", "user_friends", "ads_read", "user_birthday", "user_location", "user_likes", "user_posts", "user_religion_politics", "user_about_me", "user_education_history", "user_hometown", "user_photos"]
            loginButton.publishPermissions = ["publish_actions"]
            loginButton.delegate = facebook
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userTestButton(sender: UIButton) {
        var userArray: [User]?
        let fetchRequest = NSFetchRequest(entityName: "User")
        do {
            userArray = try managedObjectContext.executeFetchRequest(fetchRequest) as? [User]
        } catch let getUserError as NSError {
            print("Error fetching User: \(getUserError)")
        }
        let user = userArray![0]
        
        for item in user.posts! {
           let post = item as! Post
            print("Message: \(post.message!) Date: \(post.dateCreated!)")
        }
        
        let entity = NSEntityDescription.entityForName("Tone", inManagedObjectContext: managedObjectContext)
        let tones = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Tone
        
        tones.anger = 0.126792
        tones.disgust = 0.380786
        tones.fear = 0.087298
        tones.joy = 0.646714
        tones.sadness = 0.160459
        
        tones.openness = 0.812
        tones.conscientiousness = 0.916
        tones.extraversion = 0.463
        tones.agreeableness = 0.238
        tones.emotionalRange = 0.235
        
        performSegueWithIdentifier("toTones", sender: nil)
    }
    
    @IBAction func unwindFromTones(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromPost(segue: UIStoryboardSegue) {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        loginButton.delegate = nil
//        if segue.identifier == "toTones" {
//            let tonesVC = segue.destinationViewController as! TonesViewController
//            tonesVC.tones = tonesToPass
//        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
