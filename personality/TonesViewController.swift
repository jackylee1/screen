//
//  TonesViewController.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-13.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit
import CoreData

class TonesViewController: UIViewController {
    
    @IBOutlet weak var anger: ToneView!
    @IBOutlet weak var disgust: ToneView!
    @IBOutlet weak var fear: ToneView!
    @IBOutlet weak var joy: ToneView!
    @IBOutlet weak var sadness: ToneView!
    
    @IBOutlet weak var openness: ToneView!
    @IBOutlet weak var conscientiousness: ToneView!
    @IBOutlet weak var extraversion: ToneView!
    @IBOutlet weak var agreeableness: ToneView!
    @IBOutlet weak var emotionalRange: ToneView!
    
    var analyzedTone: Tone?
    
    
    let managedObjectContext = FacebookHandler.sharedInstance.managedObjectContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anger.toneAmount = analyzedTone?.anger as! CGFloat
        disgust.toneAmount = analyzedTone?.disgust as! CGFloat
        fear.toneAmount = analyzedTone?.fear as! CGFloat
        joy.toneAmount = analyzedTone?.joy as! CGFloat
        sadness.toneAmount = analyzedTone?.sadness as! CGFloat
        openness.toneAmount = analyzedTone?.openness as! CGFloat
        conscientiousness.toneAmount = analyzedTone?.conscientiousness as! CGFloat
        agreeableness.toneAmount = analyzedTone?.agreeableness as! CGFloat
        emotionalRange.toneAmount = analyzedTone?.emotionalRange as! CGFloat
        
//        let fetchRequest = NSFetchRequest(entityName: "Tone")
//        var toneArray: [Tone]?
//        
//        do {
//            toneArray = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Tone]
//        } catch let getToneError as NSError {
//            print("Error fetching Tone: \(getToneError)")
//        }
//        
//        let tones = toneArray![0]
//
//        
//        anger.toneAmount = tones.anger as! CGFloat
//        disgust.toneAmount = tones.disgust as! CGFloat
//        fear.toneAmount = tones.fear as! CGFloat
//        joy.toneAmount = tones.joy as! CGFloat
//        sadness.toneAmount = tones.sadness as! CGFloat
//        
//        openness.toneAmount = tones.openness as! CGFloat
//        conscientiousness.toneAmount = tones.conscientiousness as! CGFloat
//        extraversion.toneAmount = tones.extraversion as! CGFloat
//        agreeableness.toneAmount = tones.agreeableness as! CGFloat
//        emotionalRange.toneAmount = tones.emotionalRange as! CGFloat
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
