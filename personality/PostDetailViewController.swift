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
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.71, green:0.73, blue:0.76, alpha:1.0)
        textView.text = post?.message
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0xD6, green: 0xE7, blue: 0xEE, alpha: 0.75)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToDetailFromTonesView(segue: UIStoryboardSegue) {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reviewPostTone" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let tonesViewController = navigationController.topViewController as! TonesViewController
            tonesViewController.analyzedTone = post?.tone
            tonesViewController.disablePostToFacebook = true
        }
    }
    

}
