//
//  UserDataHandler.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-05.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import CoreData

class UserDataHandler: NSObject {
    var managedObjectContext: NSManagedObjectContext?
    
    func saveUserData(userData: AnyObject) {
        print("Save User: \(userData)")
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
            print("Create User")
            
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
                
                let entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext!)
                let post = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!)
                post.setValue(message, forKey: "message")
                post.setValue(user, forKey: "user")
                print("Post: \(post)")
                
            }
        }
        

        print("User: \(user)")
    }
    
}
