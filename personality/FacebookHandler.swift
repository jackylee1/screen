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
//                print("fetched user: \(result)")
                print("Return User Data: \(result)")
                let cognito = CognitoHandler()
                cognito.loginToCognito()

                let userDataHandler = UserDataHandler()
                userDataHandler.managedObjectContext = self.managedObjectContext
//                var userDataHandler: UserDataHandler?
//                let user = result as! NSMutableDictionary
                
                userDataHandler.saveUserData(result)
                
            }
        })
        
    }

    
}
