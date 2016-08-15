//
//  User+CoreDataProperties.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-05.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var firstname: String?
    @NSManaged var lastname: String?
    @NSManaged var gender: String?
    @NSManaged var hometown: String?
    @NSManaged var email: String?
    @NSManaged var id: String?
    @NSManaged var location: String?
    @NSManaged var political: String?
    @NSManaged var religion: String?
    @NSManaged var posts: NSSet?

}
