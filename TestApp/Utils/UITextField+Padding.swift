//
//  UITextField+Padding.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import UIKit

class CustomTextField: UITextField {

    let padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
