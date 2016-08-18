//
//  PostViewController.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-14.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit
import FBSDKShareKit

class PostViewController: UIViewController, UITextViewDelegate {
    
    let initialPlaceholderText = "What is on your mind?"
    var analyzedTone: Tone?
    var post: Post?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var textToPost: UITextView!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textToPost.delegate = self
        activityIndicator.hidesWhenStopped = true
        
        
        applyPlaceholderStyle(textToPost, placeholderText: initialPlaceholderText)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostViewController.segueToTone(_:)), name: "ToneAnalyzedForSegue", object: nil)    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func applyPlaceholderStyle(postTextView: UITextView, placeholderText: String) {
        postTextView.textColor = UIColor.lightGrayColor()
        postTextView.text = placeholderText
        clearButton.enabled = false
    }
    
    private func applyTypingStyle(postTextView: UITextView) {
        postTextView.textColor = UIColor.darkTextColor()
        postTextView.alpha = 1.0
        clearButton.enabled = true
    }
    
    @objc internal func textViewShouldBeginEditing(postTextView: UITextView) -> Bool {
        if postTextView == textToPost && postTextView.text == initialPlaceholderText {
            moveCursorToStart(postTextView)
        }
        return true
    }
    
    private func moveCursorToStart(postTextView: UITextView) {
        dispatch_async(dispatch_get_main_queue()) {
            postTextView.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newlength = textView.text.utf16.count + text.utf16.count - range.length
        if newlength > 0 {
            if textView == textToPost && textView.text == initialPlaceholderText {
                if text.utf16.count == 0 {
                    return false
                }
                applyTypingStyle(textView)
                textView.text = ""
            }
            return true

        } else {
            applyPlaceholderStyle(textView, placeholderText: initialPlaceholderText)
            moveCursorToStart(textView)
            return false
        }
    }
    
    @IBAction func didTapPostButton(sender: UIButton) {
        if textToPost.text != initialPlaceholderText {
            activityIndicator.startAnimating()
            let toneAnalyzer = WatsonToneAnalyzer()
            toneAnalyzer.analyzeTone(textToPost.text, context: "posting", post: post)
        }
    }
    
    @objc private func segueToTone(notification: NSNotification) {
        analyzedTone = (notification.userInfo!["tone" as NSObject] as! Tone)
        performSegueWithIdentifier("analyzePostTone", sender: nil)
    }
    
    @objc private func clearTextView() {
        applyPlaceholderStyle(textToPost, placeholderText: initialPlaceholderText)
    }
    
    
    @IBAction func unwindPostToFacebook(segue: UIStoryboardSegue) {
        activityIndicator.stopAnimating()
        FacebookHandler.sharedInstance.postToFeed(textToPost.text)
        viewDidLoad()
    }
    
    @IBAction func unwindDoNotPost(segue: UIStoryboardSegue) {
        activityIndicator.stopAnimating()
        viewDidLoad()
    }
    
    @IBAction func clearTextView(sender: UIBarButtonItem) {
        applyPlaceholderStyle(textToPost, placeholderText: initialPlaceholderText)

    }
    
//    @IBAction func clearButtonTapped(sender: UIButton) {
////        clearTextView()
//        applyPlaceholderStyle(textToPost, placeholderText: initialPlaceholderText)
//
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        textToPost.delegate = nil
        if segue.identifier == "analyzePostTone" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let tonesViewController = navigationController.topViewController as! TonesViewController
            tonesViewController.analyzedTone = analyzedTone
            tonesViewController.disablePostToFacebook = false
        }
    }
    

}
