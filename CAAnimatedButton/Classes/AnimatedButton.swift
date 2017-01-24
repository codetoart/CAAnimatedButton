//
//  AnimatedButton.swift
//  Animations
//
//  Created by Apple on 19/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class AnimatedButton: UIButton {
    
    fileprivate lazy var spiner: SpinerLayer! = {
        let s = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(s)
        
        return s
    }()
    
    fileprivate var spinerColor: UIColor = .white
    fileprivate var spinerWidth: CGFloat = 1
    fileprivate var title = ""
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnimatedButton {
    
    @objc fileprivate func buttonTapped() {
        if let title = self.title(for: .normal) {
            self.title = title
        }
        updateSuperView()
    }
    
    fileprivate func updateSuperView() {
        self.superview?.updateConstraints()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
    }
}

extension AnimatedButton {
    
    func shrinkView() {
        let shrinkAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnimation.fromValue = self.frame.width
        shrinkAnimation.toValue = self.frame.height
        shrinkAnimation.duration = 0.4
        shrinkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shrinkAnimation.fillMode = kCAFillModeForwards
        shrinkAnimation.isRemovedOnCompletion = false
        self.layer.add(shrinkAnimation, forKey: shrinkAnimation.keyPath)
    }
    
    func restoreView() {
        self.layer.removeAllAnimations()
        
//        let restoreAnimation = CABasicAnimation(keyPath: "bounds.size.width")
//        restoreAnimation.fromValue = self.frame.height
//        restoreAnimation.toValue = self.frame.width
//        restoreAnimation.duration = 0.4
//        restoreAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        restoreAnimation.fillMode = kCAFillModeForwards
//        restoreAnimation.isRemovedOnCompletion = false
//        self.view.layer.add(restoreAnimation, forKey: restoreAnimation.keyPath)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//            self.isHidden = false
//            self.view.layer.removeAllAnimations()
//        }
    }
    
    func expandView() {
        let expandAnimation = CABasicAnimation(keyPath: "transform.scale")
        expandAnimation.fromValue = 1
        expandAnimation.toValue = 30
        expandAnimation.duration = 0.5
        expandAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        expandAnimation.fillMode = kCAFillModeForwards
        expandAnimation.isRemovedOnCompletion = false
        self.layer.add(expandAnimation, forKey: expandAnimation.keyPath)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: {
                self.alpha = 0.4
            }, completion: { (complete) in
                self.restoreView()
                self.alpha = 1
            }
            )
        }
    }
}

extension AnimatedButton {
    
    public func startAnimating() {
        self.shrinkView()
        self.spiner.setSpinerWidth(width: self.spinerWidth)
        self.spiner.spinnerColor = self.spinerColor
        self.spiner.animation()
        
    }
    
    public func stopAnimating() {
        self.spiner.stopAnimation()
        self.expandView()
    }
    
    public func setSpinnerColor(color: UIColor = .white) {
        self.spinerColor = color
    }
    
    public func setSpinerWidth(width: CGFloat) {
        self.spinerWidth = width
    }
}
