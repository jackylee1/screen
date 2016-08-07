//
//  UserMapper.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-06.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import AWSDynamoDB

class UserMapper : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var firstname: String?
    var lastname: String?
    var gender: String?
    var hometown: String?
    var email: String?
    var ID: String?
    var location: String?
    var political: String?
    var religion: String?
    
    class func dynamoDBTableName() -> String {
        return "User"
    }
    
    class func hashKeyAttribute() -> String {
        return "ID"
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }

}