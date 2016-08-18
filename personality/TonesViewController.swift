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
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    var analyzedTone: Tone?
    let managedObjectContext = FacebookHandler.sharedInstance.managedObjectContext
    
    var disablePostToFacebook: Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.enabled = !disablePostToFacebook!
        
        if !disablePostToFacebook! {
            backButton.title = "Cancel"
            
        } else {
            postButton.tintColor = UIColor.clearColor()
            backButton.title = "Back"
        }
        
        
        
        
//        Setting the tone amount to one set the radians to draw to 3π/4 which causes it not to draw a circle as 
//        that is the start point. So we set it to very close to 1 which appears to draw a close circle.
        anger.toneAmount = (analyzedTone?.anger == 1.0 ? CGFloat(0.99999) : analyzedTone?.anger as! CGFloat)
        disgust.toneAmount = (analyzedTone?.disgust == 1.0 ? CGFloat(0.99999) : analyzedTone?.disgust as! CGFloat)
        fear.toneAmount = (analyzedTone?.fear == 1.0 ? CGFloat(0.99999) : analyzedTone?.fear as! CGFloat)
        joy.toneAmount = (analyzedTone?.joy == 1.0 ? CGFloat(0.99999) : analyzedTone?.joy as! CGFloat)
        sadness.toneAmount = (analyzedTone?.sadness == 1.0 ? CGFloat(0.99999) : analyzedTone?.sadness as! CGFloat)
        openness.toneAmount = (analyzedTone?.openness == 1.0 ? CGFloat(0.99999) : analyzedTone?.openness as! CGFloat)
        conscientiousness.toneAmount = (analyzedTone?.conscientiousness == 1.0 ? CGFloat(0.99999) : analyzedTone?.conscientiousness as! CGFloat)
        agreeableness.toneAmount = (analyzedTone?.agreeableness == 1.0 ? CGFloat(0.99999) : analyzedTone?.agreeableness as! CGFloat)
        emotionalRange.toneAmount = (analyzedTone?.emotionalRange == 1.0 ? CGFloat(0.99999) : analyzedTone?.emotionalRange as! CGFloat)
        
    }

    @IBAction func backButtonAction(sender: UIBarButtonItem) {
        if disablePostToFacebook! {
            self.performSegueWithIdentifier("unwindToDetail", sender: self)
        } else {
            self.performSegueWithIdentifier("cancelPostToFacebook", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonAction(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("postToFacebook", sender: self)
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
