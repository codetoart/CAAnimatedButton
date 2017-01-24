//
//  Helpers.swift
//  Animations
//
//  Created by Apple on 24/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func setBottomBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(
            x: 0,
            y: self.bounds.height - width,
            width:  self.bounds.width,
            height: self.bounds.height
        )
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setCornerRadius(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func addShadowToView(color: UIColor = UIColor.black) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -2, height: 0)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = color.cgColor
    }
}

extension UIFont {
    
    class func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size)!
    }
    
    class func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Medium", size: size)!
    }
    
    class func demiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: size)!
    }
}
