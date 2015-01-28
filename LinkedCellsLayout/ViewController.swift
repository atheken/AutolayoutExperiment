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

class DynamicCell : UIView{
    var leading = true
    var topConstraint : NSLayoutConstraint?
    var initialHeight:CGFloat?
}

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

func constraint(item:AnyObject, attr1:NSLayoutAttribute, relatedBy:NSLayoutRelation,
    toItem:AnyObject?, attr2:NSLayoutAttribute,
    multiplier: CGFloat, const:CGFloat) -> NSLayoutConstraint{

        return NSLayoutConstraint(item: item, attribute: attr1, relatedBy: relatedBy,
            toItem: toItem, attribute: attr2, multiplier: multiplier, constant: const)
}

class ViewController: UIViewController, UIScrollViewDelegate {

    var cells:[DynamicCell] = []
    var hasCellConstraints = false

    override func updateViewConstraints() {
        super.updateViewConstraints()

        if !hasCellConstraints && cells.count > 0 {
            hasCellConstraints = true
            var previousCell:DynamicCell?

            var i = 0

            for cell in cells {
                if let pCell = previousCell? {
                    if i == 1 {
                        var top = constraint(cell, .Top, .Equal, contentView, .Top, 1.0, 120.0)
                        cell.topConstraint = top
                        contentView.addConstraint(top)
                    }else{
                        var top = constraint(cell, .Top, .Equal, pCell, .Bottom, 1.0, 0.0)
                        cell.topConstraint = top
                        contentView.addConstraint(top)
                    }
                }else{
                    var top = constraint(cell, .Top, .Equal, contentView, .Top, 1.0, 0.0)
                    cell.topConstraint = top
                    contentView.addConstraint(top)
                }

                contentView.addConstraint(constraint(cell, .Width, .Equal, contentView, .Width, 1.0, 0.0))
                contentView.addConstraint(constraint(cell, .CenterX, .Equal, contentView, .CenterX, 1.0, 0.0))

                previousCell = cell
                i++
            }

            contentView.addConstraint(constraint(contentView, .Bottom, .Equal, previousCell!, .Bottom, 1.0, 0.0))

            self.contentView.setNeedsLayout()
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView){
        for cell in cells {
                if let c = cell as? UIScrollViewDelegate {
                    if let call = c.scrollViewDidScroll? {
                    call(scrollView)
                }
            }
        }
        contentView.layoutIfNeeded()
    }

    private var scrollView = UIScrollView();
    private var contentView = UIView();

    func setCells(cells:[DynamicCell]){

        self.cells = cells
        for cell in cells.reverse() {
            cell.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.contentView.addSubview(cell)
        }
        self.view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)

        var constraints:[NSLayoutConstraint] = []
        constraints.append(constraint(contentView, .Top, .Equal, scrollView, .Top, 1.0, 0.0))
        constraints.append(constraint(contentView, .Leading, .Equal, scrollView, .Leading, 1.0, 0.0))
        constraints.append(constraint(contentView, .Trailing, .Equal, scrollView, .Trailing, 1.0, 0.0))
        constraints.append(constraint(contentView, .Bottom, .Equal, scrollView, .Bottom, 1.0, 0.0))
        constraints.append(constraint(contentView, .Width, .Equal, view, .Width, 1.0, 0.0))

        //CenterX/CenterY does NOT work on scroll view.
        constraints.append(constraint(view, .Top, .Equal, scrollView, .Top, 1.0, 0.0))
        constraints.append(constraint(view, .Leading, .Equal, scrollView, .Leading, 1.0, 0.0))
        constraints.append(constraint(view, .Trailing, .Equal, scrollView, .Trailing, 1.0, 0.0))
        constraints.append(constraint(view, .Bottom, .Equal, scrollView, .Bottom, 1.0, 0.0))

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        self.view.addConstraints(constraints)
    }
}

