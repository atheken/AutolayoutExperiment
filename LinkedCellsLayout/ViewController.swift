//
//  ViewController.swift
//  LinkedCellsLayout
//
//  Created by Andrew Theken on 1/26/15.
//  Copyright (c) 2015 Andrew Theken. All rights reserved.
//

import UIKit

class DynamicCell : UIView{
    var leading = true
    var topConstraint : NSLayoutConstraint?
    var initialHeight:CGFloat?
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

