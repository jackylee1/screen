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

    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var screenLabel: UILabel!
    @IBOutlet weak var loginButtonToBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideButtons(true)

        self.defaults.setValue("0", forKey: "AWSUserID")
        FacebookHandler.sharedInstance.loginViewController = self
        let hasCurrentToken = FacebookHandler.sharedInstance.facebookToken()
        
        if hasCurrentToken {
            hideButtons(false)
            facebook.returnUserData()
        } else {
            loginButton.readPermissions = ["public_profile", "email", "user_friends", "ads_read", "user_birthday", "user_location", "user_likes", "user_posts", "user_religion_politics", "user_about_me", "user_education_history", "user_hometown", "user_photos"]
            loginButton.publishPermissions = ["publish_actions"]
            loginButton.delegate = facebook
        }
        
    }
    
    func hideButtons(state: Bool) {
        historyButton.hidden = state
        postButton.hidden = state
        screenLabel.hidden = !state
        
        if state == false {
            loginButtonToBottom.constant = 40
        } else {
            loginButtonToBottom.constant = 360
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindFromTones(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromPost(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromPostList(segue: UIStoryboardSegue) {
        
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
