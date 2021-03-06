//
//  FacebookHandler.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-05.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import FBSDKLoginKit


class FacebookHandler : NSObject, FBSDKLoginButtonDelegate {
    static let sharedInstance = FacebookHandler()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var loginViewController: LoginViewController?
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            print("Error logging into facebook: \(error)")
        } else if result.isCancelled {
            print("Facebook login cancelled")
        } else {
            loginViewController?.hideButtons(false)
            returnUserData()
        }
    }
    
    func facebookToken() -> Bool {
        if FBSDKAccessToken.currentAccessToken() != nil {
            return true
        }
        return false
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
        loginViewController?.hideButtons(true)
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
                                                                 parameters: ["fields": "picture, cover, photos, hometown, education, about, political, religion, feed, likes, location, birthday, locale, age_range, gender, email, first_name, last_name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                let cognito = CognitoHandler()
                cognito.loginToCognito()
                let userDataHandler = UserDataHandler.sharedInstance
                userDataHandler.managedObjectContext = self.managedObjectContext
                userDataHandler.saveUserData(result)
            }
        })
        
    }
    
    func postToFeed(textToPost: String) {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/feed",
                                                                 parameters: ["message": textToPost],
                                                                 HTTPMethod: "Post")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName("PostedToFacebook", object: nil)
            }
        })
    }
}
