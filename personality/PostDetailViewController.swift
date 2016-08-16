//
//  PostDetailViewController.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-16.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var post: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = post?.message

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromTonesView(segue: UIStoryboardSegue) {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reviewPostTone" {
            let tonesViewController = segue.destinationViewController as! TonesViewController
            tonesViewController.analyzedTone = post?.tone
            tonesViewController.disablePostToFacebook = true
        }
    }
    

}
