//
//  TonesViewController.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-13.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit

class TonesViewController: UIViewController {
    
    @IBOutlet weak var anger: ToneView!
    @IBOutlet weak var disgust: ToneView!
    @IBOutlet weak var fear: ToneView!
    @IBOutlet weak var joy: ToneView!
    @IBOutlet weak var sadness: ToneView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        anger.toneAmount = 1/5
        disgust.toneAmount = 2/5
        fear.toneAmount = 3/5
        joy.toneAmount = 4/5
        sadness.toneAmount = 0.999999
        
        // Do any additional setup after loading the view.
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
