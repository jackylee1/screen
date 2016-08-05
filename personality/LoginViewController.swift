//
//  LoginViewController.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-04.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends", "ads_read", "user_birthday", "user_location", "user_likes", "user_posts", "user_religion_politics", "user_about_me", "user_education_history", "user_hometown", "user_photos"]
        loginButton.delegate = self
        
//        if FBSDKAccessToken.currentAccessToken() != nil {
//            returnUserData()
//            let loginView = FBSDKLoginButton()
//            self.view.addSubview(loginView)
//            loginView.center = self.view.center
//            loginView.readPermissions = ["public_profile", "email", "user_friends"]
//            loginView.delegate = self
//            
//        } else {
//            let loginView = FBSDKLoginButton()
//            self.view.addSubview(loginView)
//            loginView.center = self.view.center
//            loginView.readPermissions = ["public_profile", "email", "user_friends"]
//            loginView.delegate = self
//        }
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            print("Error logging into facebook: \(error)")
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            returnUserData()
            if result.grantedPermissions.contains("email")
            {
                print("Result: \(result)")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture, cover, photos, hometown, education, about, political, religion, feed, likes, location, birthday, locale, age_range, gender, email, first_name, last_name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                if let username = result.valueForKey("name") {
                    print("Username: \(username)")
                }
            }
        })
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
