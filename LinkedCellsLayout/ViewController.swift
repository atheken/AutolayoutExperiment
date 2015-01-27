//
//  ViewController.swift
//  LinkedCellsLayout
//
//  Created by Andrew Theken on 1/26/15.
//  Copyright (c) 2015 Andrew Theken. All rights reserved.
//

import UIKit

class CustomCell : UIView {

    @IBOutlet weak var Height: NSLayoutConstraint!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        var random = CGFloat(arc4random())
        let height =  (random % 10) * 20.0;
        self.backgroundColor = UIColor(hue: (random % 100)/100, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        self.Name.text = "Height: \(height)"
        self.Height.constant = height
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.setNeedsLayout()
    }
}

func constraint(item:AnyObject, attr1:NSLayoutAttribute, relatedBy:NSLayoutRelation,
    toItem:AnyObject?, attr2:NSLayoutAttribute,
    multiplier: CGFloat, const:CGFloat) -> NSLayoutConstraint{

        return NSLayoutConstraint(item: item, attribute: attr1, relatedBy: relatedBy,
            toItem: toItem, attribute: attr2, multiplier: multiplier, constant: const)
}

class ViewController: UIViewController {

    @IBOutlet weak var ContentView: UIView!
    var nib = UINib(nibName: "CustomCell", bundle: nil)
    var cells:[CustomCell] = []
    var hasCellConstraints = false

    override func updateViewConstraints() {
        super.updateViewConstraints()

        if !hasCellConstraints && cells.count > 0 {
            hasCellConstraints = true
            var previousCell:CustomCell?

            for cell in cells {
                if let pCell = previousCell? {
                    ContentView.addConstraint(constraint(cell, .Top, .Equal, pCell, .Bottom, 1.0, 0.0))
                }else{
                    ContentView.addConstraint(constraint(cell, .Top, .Equal, ContentView, .Top, 1.0, 0.0))
                }

                ContentView.addConstraint(constraint(cell, .Width, .Equal, ContentView, .Width, 1.0, 0.0))
                ContentView.addConstraint(constraint(cell, .CenterX, .Equal, ContentView, .CenterX, 1.0, 0.0))

                previousCell = cell
            }
            println("Content View Sets Resizing Mask Constraints? \(ContentView.translatesAutoresizingMaskIntoConstraints())")
            ContentView.addConstraint(constraint(ContentView, .Bottom, .Equal, previousCell!, .Bottom, 1.0, 0.0))

            self.ContentView.setNeedsLayout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for var i = 0; i < 10; i++ {
            var cell = nib.instantiateWithOwner(self, options: nil)[0] as CustomCell
            self.ContentView.addSubview(cell)
            self.cells.append(cell)
        }
        
        self.view.setNeedsUpdateConstraints()
    }
}

