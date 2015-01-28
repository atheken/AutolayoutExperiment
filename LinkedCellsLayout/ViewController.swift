//
//  ViewController.swift
//  LinkedCellsLayout
//
//  Created by Andrew Theken on 1/26/15.
//  Copyright (c) 2015 Andrew Theken. All rights reserved.
//

import UIKit

@IBDesignable
class TranslateResizeMaskToConstraints: UIView {

    @IBInspectable var Enabled:Bool = false

    private var _interfaceBuilderContext = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setTranslatesAutoresizingMaskIntoConstraints(Enabled || _interfaceBuilderContext)
    }


    override func prepareForInterfaceBuilder() {
        _interfaceBuilderContext = true
    }
}

class CustomCell : TranslateResizeMaskToConstraints, UIScrollViewDelegate {

    var cellIndex = 0
    var h = CGFloat(120.0)

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if cellIndex == 0 {
            let offset = scrollView.contentOffset.y
            var top = self.constraintsAffectingLayoutForAxis(.Vertical).first as NSLayoutConstraint
            if  offset < 0 {
                self.Height.constant = self.h - offset;
                top.constant = scrollView.contentOffset.y
            } else if offset >= 0 {
                self.Height.constant = h;

                var constant = offset

                if (constant >= 40.0) {
                    constant = 40.0
                }
                top.constant = constant
            }
            self.setNeedsLayout()
        }
    }

    func randomizeHeight(){
        var random = CGFloat(arc4random())
        let height =  (random % 100) + 20;
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

func constraint(item:AnyObject, attr1:NSLayoutAttribute, relatedBy:NSLayoutRelation,
    toItem:AnyObject?, attr2:NSLayoutAttribute,
    multiplier: CGFloat, const:CGFloat) -> NSLayoutConstraint{

        return NSLayoutConstraint(item: item, attribute: attr1, relatedBy: relatedBy,
            toItem: toItem, attribute: attr2, multiplier: multiplier, constant: const)
}

class ViewController: UIViewController, UIScrollViewDelegate {

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
                    contentView.addConstraint(constraint(cell, .Top, .Equal, pCell, .Bottom, 1.0, 0.0))
                }else{
                    contentView.addConstraint(constraint(cell, .Top, .Equal, contentView, .Top, 1.0, 0.0))
                }

                contentView.addConstraint(constraint(cell, .Width, .Equal, contentView, .Width, 1.0, 0.0))
                contentView.addConstraint(constraint(cell, .CenterX, .Equal, contentView, .CenterX, 1.0, 0.0))

                previousCell = cell
            }

            contentView.addConstraint(constraint(contentView, .Bottom, .Equal, previousCell!, .Bottom, 1.0, 0.0))

            self.contentView.setNeedsLayout()
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView){
        for cell in cells {
            cell.scrollViewDidScroll(scrollView)
        }
        contentView.layoutIfNeeded()
    }

    private var scrollView = UIScrollView();
    private var contentView = UIView();

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)

        var constraints = [
            constraint(contentView, .Top, .Equal, scrollView, .Top, 1.0, 0.0),
            constraint(contentView, .Leading, .Equal, scrollView, .Leading, 1.0, 0.0),
            constraint(contentView, .Trailing, .Equal, scrollView, .Trailing, 1.0, 0.0),
            constraint(contentView, .Bottom, .Equal, scrollView, .Bottom, 1.0, 0.0),
            constraint(contentView, .Width, .Equal, view, .Width, 1.0, 0.0),

            //CenterX/CenterY does NOT work on scroll view.
            constraint(view, .Top, .Equal, scrollView, .Top, 1.0, 0.0),
            constraint(view, .Leading, .Equal, scrollView, .Leading, 1.0, 0.0),
            constraint(view, .Trailing, .Equal, scrollView, .Trailing, 1.0, 0.0),
            constraint(view, .Bottom, .Equal, scrollView, .Bottom, 1.0, 0.0)
        ]

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        self.view.addConstraints(constraints)

        for var i = 0; i < 10; i++ {
            var cell = nib.instantiateWithOwner(self, options: nil)[0] as CustomCell
            cell.cellIndex = i
            self.contentView.addSubview(cell)
            self.cells.append(cell)
        }
        
        self.view.setNeedsUpdateConstraints()
    }
}

