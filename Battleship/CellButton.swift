//
//  GridButton.swift
//  Battleship
//
//  Created by Pei Liu on 11/9/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class CellButton: UIView {

    var x: Int = 0
    var y: Int = 0
    weak var Delegate: CellButtonDelegate? = nil
    var buttonStatus: myStatus = .isWater
    var isVisited = false
    var bgColor: UIColor = Singleton.sharedInstance.waterColor
    var text: String?
    
    init(frame: CGRect, delegate: CellButtonDelegate) {
        super.init(frame: frame)
        Delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Override touchesBegan to set this view if touchable or not
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Delegate?.updateButton(x, col: y)
    }

    // Custom draw text
    func drawText(text: String?) {
        if (text == nil) {
            return
        } else {
            let s: NSString = text!
            let fieldColor: UIColor = UIColor.blackColor()
            let fieldFont = UIFont(name: "Helvetica Neue", size: bounds.width / 2)
            let attributes: NSDictionary = [
                NSForegroundColorAttributeName: fieldColor,
                NSFontAttributeName: fieldFont!
            ]
            s.drawInRect(CGRectMake(bounds.width / 4, bounds.width / 4, bounds.width, bounds.height), withAttributes: attributes as? [String : AnyObject])
        }
    }
    
    // Draw custom UI button
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let xPos = bounds.origin.x + 1
        let yPos = bounds.origin.y + 1
        let width = bounds.size.width - 2
        let height = bounds.size.width - 2
        let button = CGRectMake(xPos, yPos, width, height)
        
        CGContextAddRect(context!, button)
        CGContextSetFillColorWithColor(context!, bgColor.CGColor)
        CGContextFillRect(context!, button)
        drawText(text)
    }
    
    // Update color of the button
    private func updateButtonColor() {
        switch buttonStatus {
        case .isMissed:
            bgColor = .whiteColor()
            userInteractionEnabled = false
            isVisited = true
            text = "M"
        case .isHit:
            bgColor = .redColor()
            userInteractionEnabled = false
            isVisited = true
            text = "H"
        case .isShip:
            bgColor = Singleton.sharedInstance.shipColor
            text = nil
        case .isWater:
            bgColor = Singleton.sharedInstance.waterColor
            text = nil
        case .isSelected:
            bgColor = .orangeColor()
            text = "╳"
        case .isSunk:
            bgColor = Singleton.sharedInstance.sunkColor
            text = "S"
        }
    }
    
    // Compute current button status
    var buttonCurrentStatus: myStatus {
        get {
            return buttonStatus
        }
        set{
            if !isVisited {
                buttonStatus = newValue
                updateButtonColor()
                setNeedsDisplay()
            }
        }
    }
    
    
}
