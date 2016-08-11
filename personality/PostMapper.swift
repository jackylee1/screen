//
//  PostMapper.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-10.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import AWSDynamoDB

class PostMapper : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    var message: String?
    var UserID: String?
    var DateCreated: NSNumber?
    
    class func dynamoDBTableName() -> String {
        return "Post"
    }
    
    class func hashKeyAttribute() -> String {
        return "UserID"
    }
    
    class func rangeKeyAttribute() -> String {
        return "DateCreated"
    }

    override func isEqual(object: AnyObject!) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
}
