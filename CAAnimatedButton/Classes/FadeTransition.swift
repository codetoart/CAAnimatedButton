//
//  FadeTransition.swift
//  Animations
//
//  Created by Apple on 23/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

open class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 0.5
    var intialAlpha: CGFloat = 0.0
    
    public convenience init(transitionDuration: TimeInterval, startingAlpha: CGFloat) {
        self.init()
        
        self.duration = transitionDuration
        self.intialAlpha = startingAlpha
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let containerView = transitionContext.containerView
        toView.alpha = self.intialAlpha
        fromView.alpha = 0.8
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: self.duration, animations: { () -> Void in
            
            toView.alpha = 1.0
            fromView.alpha = 0.0
            
        }, completion: {
            _ in
            fromView.alpha = 1.0
            transitionContext.completeTransition(true)
        })
    }
}
