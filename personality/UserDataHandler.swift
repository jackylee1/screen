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
    static let sharedInstance = UserDataHandler()
    var managedObjectContext: NSManagedObjectContext?
    var credentialsProvider: AWSCognitoCredentialsProvider?
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override init() {
        super.init()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserDataHandler.saveTone), name: "ToneAnalyzedForSave", object: nil)
    }
    
    func saveUserData(userData: AnyObject) {
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
        var user: User
        
        if userArray?.count > 0 {
            user = userArray![0]
            print("User Array")
        } else {
            let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext!)
            user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!) as! User
        }
        
        user.id = userData.valueForKey("id") as? String
        user.email = userData.valueForKey("email") as? String
        user.firstname = userData.valueForKey("first_name") as? String
        user.lastname = userData.valueForKey("last_name") as? String
        user.gender = userData.valueForKey("gender") as? String
        user.political = userData.valueForKey("political") as? String
        user.religion = userData.valueForKey("religion") as? String
        user.hometown = userData.valueForKey("hometown")?.valueForKey("name") as? String
        user.location = userData.valueForKey("location")?.valueForKey("name") as? String
        
        let posts = userData.valueForKey("feed")?.valueForKey("data") as!
            [AnyObject]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        
        for item in posts {
            if let message = item.valueForKey("message") as? String {
                let date = item.valueForKey("created_time") as! String
                let dateValue = dateFormatter.dateFromString(date)
                let epoch = dateValue?.timeIntervalSince1970
                
                var post: Post?
                
                post = getPost(message)
                
                if let _ = post {} else {
                    let entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext!)
                    post = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!) as? Post
                }
                
                post!.message = message
                post!.dateCreated = epoch!
                post!.user = user
            }
        }
        analyzePostTone(id!)
        saveUserToDynamoDB(id!)
        savePostToDynamoDB(id!)
    }
    
    private func getPost(message: String) -> Post? {
        let fetchRequest = NSFetchRequest(entityName: "Post")
        let postPredicate = NSPredicate(format: "message == %@", argumentArray: [message])
        fetchRequest.predicate = postPredicate

        var postArray: [Post]?
        var post: Post?

        do {
            postArray = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [Post]
        } catch let getUserError as NSError {
            print("Error fetching User: \(getUserError)")
        }
        
        if postArray?.count > 0 {
            post = postArray![0]
        }
        
        return post

    }
    
    
    private func saveUserToDynamoDB(id: AnyObject) {
//
        let user = fetchUser(id)
        let userMapper = UserMapper()
        
        userMapper.firstname = user.firstname!
        userMapper.lastname = user.lastname!
        userMapper.gender = user.gender!
        userMapper.hometown = user.hometown!
        userMapper.email = user.email!
        userMapper.UserID = (defaults.valueForKey("AWSUserID") as! String)
        userMapper.location = user.location!
        userMapper.political = user.political!
        userMapper.religion = user.religion!
        
        if(credentialsProvider == nil){
            credentialsProvider = AWSCognitoCredentialsProvider.init(regionType: Constants.regionType, identityId: nil, accountId: nil, identityPoolId: Constants.idPool, unauthRoleArn: nil, authRoleArn: nil, logins: nil)
//            print("***Credentials was nil***")
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
            }
            return nil
        }
    }
    
    private func analyzePostTone(id: AnyObject) {
        let user = fetchUser(id)
        let toneAnalyzer = WatsonToneAnalyzer()
        
        for post in user.posts! {
            let postToAnalyze = post as! Post
            toneAnalyzer.analyzeTone(post.message, context: "saving", post: postToAnalyze)
        }
        
    }
    
    @objc private func saveTone(notification: NSNotification) {
//        let post = (notification.userInfo!["post" as NSObject] as! Post)
        let tone = (notification.userInfo!["tone" as NSObject] as! Tone)
        
        let fetchRequest = NSFetchRequest(entityName: "Post")
        let userPredicate = NSPredicate(format: "message == %@", argumentArray: [tone.text!])
        fetchRequest.predicate = userPredicate
        
        var postArray: [Post]?
        
        do {
            postArray = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [Post]
        } catch let getUserError as NSError {
            print("Error fetching User: \(getUserError)")
        }
        let post = postArray![0]
        
        
        post.tone = tone

        
        
    }
    
    private func fetchUser(id: AnyObject) -> User{
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
        
        return user

    }
    
    private func savePostToDynamoDB(id: AnyObject) {
//        let fetchRequest = NSFetchRequest(entityName: "User")
//        let userPredicate = NSPredicate(format: "id == %@", argumentArray: [id])
//        fetchRequest.predicate = userPredicate
//        
//        var userArray: [User]?
//        
//        do {
//            userArray = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [User]
//        } catch let getUserError as NSError {
//            print("Error fetching User: \(getUserError)")
//        }
        let user = fetchUser(id)
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
                }
                return nil
            }
        }
    }
}
