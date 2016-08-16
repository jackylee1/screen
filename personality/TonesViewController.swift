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
