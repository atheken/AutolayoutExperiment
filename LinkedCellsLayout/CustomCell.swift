//
//  CustomCell.swift
//  LinkedCellsLayout
//
//  Created by Andrew Theken on 1/28/15.
//  Copyright (c) 2015 Andrew Theken. All rights reserved.
//

import Foundation
import UIKit

class CustomCell : DynamicCell, UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if leading {
            var top = topConstraint!

            if  offset < 0 {
                self.Height.constant = (initialHeight ?? CGFloat(0.0)) - offset;
                top.constant = scrollView.contentOffset.y
            } else if offset >= 0 {
                self.Height.constant = initialHeight ?? CGFloat(0.0);

                var constant = offset

                if (constant >= 40.0) {
                    constant -= 40.0
                }else {
                    constant = 0
                }

                top.constant = constant
            }
            self.setNeedsLayout()
        }
    }

    func randomizeHeight(){
        var random = CGFloat(arc4random())
        let height = leading ? CGFloat(120.0) : ((random % 100) + 20);
        initialHeight = height
        self.backgroundColor = UIColor(hue: (random % 100)/100, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        self.Name.text = "Height: \(height)"
        self.Height.constant = height
    }

    @IBAction func RandomizeHeight(sender: AnyObject) {
        layoutIfNeeded()
        UIView.animateWithDuration(0.5){
            self.randomizeHeight()
            self.setNeedsLayout()
        }
    }

    @IBOutlet weak var Height: NSLayoutConstraint!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        randomizeHeight()
        self.setNeedsLayout()
    }
}
