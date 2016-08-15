//
//  ToneView.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-13.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit

let π = CGFloat(M_PI)

@IBDesignable class ToneView: UIView {

    @IBInspectable var backgroundColour = UIColor.lightGrayColor()
    
    @IBInspectable internal var toneAmount: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable internal var toneColour: UIColor = UIColor.lightGrayColor(){
        didSet { setNeedsDisplay() }
    }
    
    
    override func drawRect(rect: CGRect) {
        let center = CGPoint(x:bounds.width/2, y:bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let arcWidth: CGFloat = 6
        
        let backgroundStartAngle: CGFloat = π
        let backgroundEndAngle: CGFloat = 4*π
        
        let backgroundPath = UIBezierPath(arcCenter: center,
                                          radius: radius/2 - arcWidth/2,
                                          startAngle: backgroundStartAngle,
                                          endAngle: backgroundEndAngle,
                                          clockwise: true)
        backgroundPath.lineWidth = arcWidth
        backgroundColour.setStroke()
        backgroundPath.stroke()
//        Arcs are drawn using radians for start and end points. To calculate the endpoint
//        multiply 360 degrees by the tone amount then multiply by π/180 to convert to radians.
        let toneStartAngle = 3*π/2
        let toneEndAngle:CGFloat = ((toneAmount*360)-90) * (π/180)
        
        let tonePath = UIBezierPath(arcCenter: center,
                                    radius: radius/2 - arcWidth/2,
                                    startAngle: toneStartAngle,
                                    endAngle: toneEndAngle,
                                    clockwise: true)
        tonePath.lineWidth = arcWidth
        toneColour.setStroke()
        tonePath.stroke()
    }


}
