//
//  CognitoHandler.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-06.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import AWSCognito
import AWSCore
import FBSDKLoginKit

class CognitoHandler
{
    var credentialsProvider: AWSCognitoCredentialsProvider?
    var defaults = NSUserDefaults.standardUserDefaults()
    
    func loginToCognito() {
        let idToken = FBSDKAccessToken.currentAccessToken().tokenString
        
        if(credentialsProvider == nil){
            credentialsProvider = AWSCognitoCredentialsProvider.init(regionType: Constants.regionType, identityId: nil, accountId: nil, identityPoolId: Constants.idPool, unauthRoleArn: nil, authRoleArn: nil, logins: nil)
                        print("***Credentials was nil***")
        }
        
        let configuration = AWSServiceConfiguration(region: Constants.regionType, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        credentialsProvider!.logins = [AWSCognitoLoginProviderKey.Facebook.rawValue : idToken]

        
        credentialsProvider!.getIdentityId().continueWithBlock { (task: AWSTask!) -> AnyObject! in
            if(task.error != nil) {
                print("Cognito Error: " + task.error!.localizedDescription)
            } else {
                print("Successful Login to Cognito")
                print("Cognito Success: \(task.result)")
                self.defaults.setValue("\(task.result!)", forKey: "AWSUserID")
                
            }
            return nil
        }
        
    }
}
