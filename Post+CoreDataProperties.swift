//
//  Post+CoreDataProperties.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-11.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var dateCreated: NSNumber?
    @NSManaged var message: String?
    @NSManaged var user: User?

}
