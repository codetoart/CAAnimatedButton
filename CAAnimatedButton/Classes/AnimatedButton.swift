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
    fileprivate var shrinkDuration: CFTimeInterval = 0.4
    fileprivate var restoreDuration: CFTimeInterval = 0.4
    fileprivate var transitionDuration: CFTimeInterval = 0.5
    fileprivate var isAnimationStart: Bool = false
    
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
    
    fileprivate func shrinkView() {
        let shrinkAnimation = CABasicAnimation(
            keyPath: "bounds.size.width"
        )
        shrinkAnimation.fromValue = self.frame.width
        shrinkAnimation.toValue = self.frame.height
        shrinkAnimation.duration = shrinkDuration
        shrinkAnimation.timingFunction = CAMediaTimingFunction(
            name: kCAMediaTimingFunctionLinear
        )
        shrinkAnimation.fillMode = kCAFillModeForwards
        shrinkAnimation.isRemovedOnCompletion = false
        self.layer.add(shrinkAnimation, forKey: shrinkAnimation.keyPath)
    }
    
    fileprivate func restoreView() {
        let restoreAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        restoreAnimation.fromValue = self.frame.height
        restoreAnimation.toValue = self.frame.width
        restoreAnimation.duration = restoreDuration
        restoreAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        restoreAnimation.fillMode = kCAFillModeForwards
        restoreAnimation.isRemovedOnCompletion = false
        self.layer.add(restoreAnimation, forKey: restoreAnimation.keyPath)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + restoreDuration) {
            self.layer.removeAllAnimations()
        }
    }
    
    fileprivate func expandView() {
        let expandAnimation = CABasicAnimation(
            keyPath: "transform.scale"
        )
        expandAnimation.fromValue = 1
        expandAnimation.toValue = 30
        expandAnimation.duration = transitionDuration
        expandAnimation.timingFunction = CAMediaTimingFunction(
            name: kCAMediaTimingFunctionEaseInEaseOut
        )
        expandAnimation.fillMode = kCAFillModeForwards
        expandAnimation.isRemovedOnCompletion = false
        self.layer.add(expandAnimation, forKey: expandAnimation.keyPath)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration) {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.curveLinear],
                animations: {
                    self.alpha = 0.4
                },
                completion: { (complete) in
                    self.layer.removeAllAnimations()
                    self.alpha = 1
                }
            )
        }
    }
}

extension AnimatedButton {
    
    public func startAnimating() {
        self.isAnimationStart = true
        self.isEnabled = false
        self.setTitle(nil, for: .normal)
        self.shrinkView()
        self.spiner.setSpinerWidth(width: self.spinerWidth)
        self.spiner.spinnerColor = self.spinerColor
        DispatchQueue.main.asyncAfter(deadline: .now() + shrinkDuration) {
            self.spiner.animation()
        }
    }
    
    public func stopAnimating(isAllowTransition: Bool = false) {
        if self.isAnimationStart {
            self.isAnimationStart = false
            self.spiner.stopAnimation()
            var duration: CFTimeInterval = transitionDuration
            if isAllowTransition {
                self.expandView()
                duration = transitionDuration
            } else {
                restoreView()
                duration = restoreDuration
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.setTitle(self.title, for: .normal)
                self.isEnabled = true
            }
        }
    }
    
    public func setSpinnerColor(color: UIColor = .white) {
        self.spinerColor = color
    }
    
    public func setSpinerWidth(width: CGFloat) {
        self.spinerWidth = width
    }
    
    public func setShrinkDuration(duration: CFTimeInterval) {
        self.shrinkDuration = duration
        self.restoreDuration = duration
    }

    public func setTransitionDuration(duration: CFTimeInterval) {
        self.transitionDuration = duration
    }
    
    public func finishTransition(withDelay delay: TimeInterval, completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if let comp = completion {
                comp()
            }
        }
    }
    
    public func isAnimating() -> Bool {
        return self.isAnimationStart
    }
}
