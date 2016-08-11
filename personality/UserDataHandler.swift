//
//  UserDataHandler.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-05.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import CoreData
import AWSDynamoDB
import AWSCognito
import FBSDKLoginKit



class UserDataHandler: NSObject {
    var managedObjectContext: NSManagedObjectContext?
    var credentialsProvider: AWSCognitoCredentialsProvider?
    var defaults = NSUserDefaults.standardUserDefaults()
    
    func saveUserData(userData: AnyObject) {
//        print("Save User: \(userData)")
        let id = userData.valueForKey("id")
        let fetchRequest = NSFetchRequest(entityName: "User")
        let userPredicate = NSPredicate(format: "id == %@", argumentArray: [id!])
        fetchRequest.predicate = userPredicate
        
        var userArray: [User]?
        
        do {
            userArray = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [User]
        } catch let getUserError as NSError {
            print("Error fetching User: \(getUserError)")
        }
        var user: AnyObject?
        
        if userArray?.count > 0 {
            user = userArray![0]
            print("User Array")
        } else {
            let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext!)
            user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!)
//            print("Create User")
            
        }
        
        user?.setValue(userData.valueForKey("id"), forKey: "id")
        user?.setValue(userData.valueForKey("email"), forKey: "email")
        user?.setValue(userData.valueForKey("last_name"), forKey: "lastname")
        user?.setValue(userData.valueForKey("first_name"), forKey: "firstname")
        user?.setValue(userData.valueForKey("gender"), forKey: "gender")
        user?.setValue(userData.valueForKey("political"), forKey: "political")
        user?.setValue(userData.valueForKey("religion"), forKey: "religion")
        user?.setValue(userData.valueForKey("hometown")?.valueForKey("name"), forKey: "hometown")
        user?.setValue(userData.valueForKey("location")?.valueForKey("name"), forKey: "location")
        
        let posts = userData.valueForKey("feed")?.valueForKey("data") as! [AnyObject]
        
        for item in posts {
            if let message = item.valueForKey("message") {
                let date = item.valueForKey("created_time")
                let entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext!)
                let post = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!)
                post.setValue(message, forKey: "message")
                post.setValue(date, forKey: "dateCreated")
                post.setValue(user, forKey: "user")
//                print("Post: \(post)")
                
            }
        }
        

//        print("User: \(user)")
        saveUserToDynamoDB(id!)
        savePostToDynamoDB(id!)
        
    }
    
    
    private func saveUserToDynamoDB(id: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName: "User")
        let userPredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = userPredicate
        
        var userArray: [User]?
        
        do {
            userArray = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [User]
        } catch let getUserError as NSError {
            print("Error fetching User: \(getUserError)")
        }
        
        let user = userArray![0]
    
        let userMapper = UserMapper()
        
        userMapper.firstname = user.firstname!
        userMapper.lastname = user.lastname!
        userMapper.gender = user.gender!
        userMapper.hometown = user.hometown!
        userMapper.email = user.email!
//        userMapper.ID = user.id!
        userMapper.UserID = (defaults.valueForKey("AWSUserID") as! String)
//        print("UserID: \(user.id!)")
        userMapper.location = user.location!
        userMapper.political = user.political!
        userMapper.religion = user.religion!
        
        if(credentialsProvider == nil){
            credentialsProvider = AWSCognitoCredentialsProvider.init(regionType: Constants.regionType, identityId: nil, accountId: nil, identityPoolId: Constants.idPool, unauthRoleArn: nil, authRoleArn: nil, logins: nil)
            print("***Credentials was nil***")
        }
        let idToken = FBSDKAccessToken.currentAccessToken().tokenString
        credentialsProvider!.logins = [AWSCognitoLoginProviderKey.Facebook.rawValue : idToken]

        let configuration = AWSServiceConfiguration(region: Constants.regionType, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration

        
        let mapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        mapper.save(userMapper).continueWithBlock { (task: AWSTask!) -> AnyObject! in
            if(task.error != nil) {
                print("Dynamo Error: \(task.error)")
                return nil
            } else {
                print("Save User to AWS: \(task)")
            }
            return nil
        }

    }
    
    private func savePostToDynamoDB(id: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName: "User")
        let userPredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = userPredicate
        
        var userArray: [User]?
        
        do {
            userArray = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [User]
        } catch let getUserError as NSError {
            print("Error fetching User: \(getUserError)")
        }
        
        let user = userArray![0]
        let facebookPost = PostMapper()
        
        for item in user.posts! {
            let post = item as! Post
            
            facebookPost.UserID = (defaults.valueForKey("AWSUserID") as! String)
            facebookPost.message = post.message
            facebookPost.DateCreated = post.dateCreated
            
            let idToken = FBSDKAccessToken.currentAccessToken().tokenString
            credentialsProvider!.logins = [AWSCognitoLoginProviderKey.Facebook.rawValue : idToken]
            
            let configuration = AWSServiceConfiguration(region: Constants.regionType, credentialsProvider: credentialsProvider)
            
            AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
            
            
            let mapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
            mapper.save(facebookPost).continueWithBlock { (task: AWSTask!) -> AnyObject! in
                if(task.error != nil) {
                    print("Dynamo Error: \(task.error)")
                    return nil
                } else {
                    print("Save User to AWS: \(task)")
                }
                return nil
            }

            
        }

    }
    
}
