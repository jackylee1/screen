//
//  ToneAnalyzer.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-11.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import ToneAnalyzerV3

class WatsonToneAnalyzer
{
    func analyzeTone (text: String) {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let version = dateFormatter.stringFromDate(currentDate)
        
        let username = Constants.watson_username
        let password = Constants.watson_password
        
        let toneAnalyzer = ToneAnalyzer(username: username, password: password, version: version)
        
        
        let failure = { (error: NSError) in print(error) }
        
    
        toneAnalyzer.getTone(text, failure: failure)  { tones in
//            print(text)
//            print()
            self.processAnalyzedTone(tones,text: text)
        }
    }
    private func processAnalyzedTone(tones: ToneAnalysis, text: String) {
//        print("\(tones.documentTone[1].tones[1].name) : \(tones.documentTone[1].tones[1].score)")
        
        print(text)
        print()

        let documentTones = tones.documentTone
        for item in documentTones {
            print("\(item.name):")
            let tonescore = item.tones
            for score in tonescore {
                print("\(score.name) : \(score.score)")
            }
            print()
        }
        print("--------------------")
        
//        let sentenceTones = tones.sentencesTones
//        for sentence in sentenceTones! {
//            print("\(sentence.sentenceID) - \(sentence.text)")
//            let toneCatagories = sentence.toneCategories
//            for eachTone in toneCatagories {
////                print("\(eachTone.name): \(eachTone.tones)")
//                let toneType = eachTone.tones
//                for individualTone in toneType {
//                    print("\(individualTone.name): \(individualTone.score)")
//                }
//            }
//            print()

//        }
        
    }
    
}
