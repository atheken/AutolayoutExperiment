//
//  Utilities.swift
//  LinkedCellsLayout
//
//  Created by Andrew Theken on 1/28/15.
//  Copyright (c) 2015 Andrew Theken. All rights reserved.
//

import Foundation
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

func constraint(item:AnyObject, attr1:NSLayoutAttribute, relatedBy:NSLayoutRelation,
    toItem:AnyObject?, attr2:NSLayoutAttribute,
    multiplier: CGFloat, const:CGFloat) -> NSLayoutConstraint{

        return NSLayoutConstraint(item: item, attribute: attr1, relatedBy: relatedBy,
            toItem: toItem, attribute: attr2, multiplier: multiplier, constant: const)
}

/*
extension UIView {
    func addConstraint(attr1:NSLayoutAttribute, relatedBy:NSLayoutRelation,
        toItem:AnyObject?, attr2:NSLayoutAttribute, multiplier: CGFloat, const:CGFloat){

        self.addConstraint(NSLayoutConstraint(item: self, attribute: attr1, relatedBy: relatedBy, toItem: toItem, attribute: attr2, multiplier: multiplier, constant: const))
    }
}
*/