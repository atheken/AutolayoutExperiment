//
//  ViewController.swift
//  LinkedCellsLayout
//
//  Created by Andrew Theken on 1/26/15.
//  Copyright (c) 2015 Andrew Theken. All rights reserved.
//

import UIKit

class CustomCell : UIView {
    override func translatesAutoresizingMaskIntoConstraints() -> Bool {
        return false
    }

    override func intrinsicContentSize() -> CGSize {
        var size = self.frame.size
        return size
    }
}

class CustomView : UIView {

    private var lastBounds: CGRect = CGRectZero

    /*
    override func layoutSubviews() {
        super.layoutSubviews()
        if !CGRectEqualToRect(self.bounds, lastBounds){
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        //self.layoutIfNeeded() //leads to stack overflow
        lastBounds = self.bounds

        }
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()

        for var i = 10.0; i > 0; i-- {
            var cell = NSBundle.mainBundle().loadNibNamed("CustomView", owner: nil, options: nil)[0] as CustomCell
            let green = CGFloat(0.1 * i)

            cell.backgroundColor = UIColor(red: 0, green: green, blue: 0, alpha:1.0)

            //cell.frame = CGRect(x: 0, y: 0, width: 600, height: CGFloat(20 * i))

            //set this to false, or constraints are installed that are not compatible.
            cell.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(cell)
        }

        self.addLinkingConstraints()
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    func addLinkingConstraints() {
        var previousCell:UIView? = nil

        var views = self.subviews.map({$0 as UIView})

        for i in  views{
            if let pCell = previousCell? {
                self.addConstraint(NSLayoutConstraint(item: pCell, attribute: .Bottom, relatedBy: .Equal, toItem: i, attribute: .Top, multiplier: 1.0, constant: 0.0))
            }
            else{
                self.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: i, attribute: .Top, multiplier: 1.0, constant: 0.0))
            }

            self.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: i, attribute: .CenterX, multiplier: 1.0, constant: 0.0))

            self.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: i, attribute: .Width, multiplier: 1.0, constant: 0.0))

            previousCell = i
        }
    }
}

class ViewController: UIViewController {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

