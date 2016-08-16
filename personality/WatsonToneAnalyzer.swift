//
//  ToneAnalyzer.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-11.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import ToneAnalyzerV3
import CoreData

class WatsonToneAnalyzer
{
    let managedObjectContext = FacebookHandler.sharedInstance.managedObjectContext
    var postContext: String?
    var originalPost: Post?
    
    func analyzeTone (text: String, context: String, post: Post?) {
        postContext = context
        if context == "saving" {
            originalPost = post
        }
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let version = dateFormatter.stringFromDate(currentDate)
        
        let username = Constants.watson_username
        let password = Constants.watson_password
        
        let toneAnalyzer = ToneAnalyzer(username: username, password: password, version: version)
        
        let failure = { (error: NSError) in print(error) }
        toneAnalyzer.getTone(text, failure: failure) { tones in
            self.processAnalyzedTone(tones,text: text)
        }
        
    }
    
    private func processAnalyzedTone(tones: ToneAnalysis, text: String){
        let entity = NSEntityDescription.entityForName("Tone", inManagedObjectContext: managedObjectContext)
        let toneToReturn = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Tone

        toneToReturn.text = text
        
        print(text)
        print()

        let documentTones = tones.documentTone
        for item in documentTones {
            let tonescore = item.tones
            for score in tonescore {
                print("\(score.name) : \(score.score)")
                if score.name != "Emotional Range" {
                    toneToReturn.setValue(score.score, forKey: "\(score.name)")
                } else {
                    toneToReturn.setValue(score.score, forKey: "emotionalRange")

                }
            }
            print()
        }
        print("--------------------")
        
        let nc = NSNotificationCenter.defaultCenter()
        
        
        let   dictionary = ["tone": toneToReturn]
        
        
        if postContext == "posting" {
            nc.postNotificationName("ToneAnalyzedForSegue", object: nil, userInfo: dictionary)
        } else if postContext == "saving" {
            nc.postNotificationName("ToneAnalyzedForSave", object: nil, userInfo: dictionary)

        }
    }
}
