//
//  Tone+CoreDataProperties.swift
//  
//
//  Created by Martin Conklin on 2016-08-14.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tone {

    @NSManaged var anger: NSNumber?
    @NSManaged var disgust: NSNumber?
    @NSManaged var fear: NSNumber?
    @NSManaged var joy: NSNumber?
    @NSManaged var sadness: NSNumber?
    @NSManaged var openness: NSNumber?
    @NSManaged var conscientiousness: NSNumber?
    @NSManaged var extraversion: NSNumber?
    @NSManaged var agreeableness: NSNumber?
    @NSManaged var emotionalRange: NSNumber?
    @NSManaged var analytical: NSNumber?
    @NSManaged var confident: NSNumber?
    @NSManaged var tentative: NSNumber?
    @NSManaged var text: String?
    @NSManaged var post: Post?
    

}
