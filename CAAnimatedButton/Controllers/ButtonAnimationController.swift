//
//  ButtonAnimationController.swift
//  Animations
//
//  Created by Apple on 19/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ButtonAnimationController: UIViewController {

    fileprivate var animatingButton = AnimatedButton()
    fileprivate var stopButton = AnimatedButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        setupButton()
        setupStopButton()
        
        self.edgesForExtendedLayout = .bottom
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ButtonAnimationController {
    
    func setupButton() {
        self.view.addSubview(self.animatingButton)
        let constaints = [
            self.animatingButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            self.animatingButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.animatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            self.animatingButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constaints)
        
        self.animatingButton.backgroundColor = UIColor.orange
        self.animatingButton.addTarget(
            self,
            action: #selector(animationButtonTapped),
            for: .touchUpInside
        )
        self.animatingButton.setCornerRadius(radius: 25)
        self.animatingButton.setSpinnerColor(color: UIColor.white)
        self.animatingButton.setShrinkDuration(duration: 0.3)
        self.animatingButton.setSpinerWidth(width: 1.5)
        self.animatingButton.setTitle("Click here", for: .normal)
        self.animatingButton.setTitleColor(UIColor.white, for: .normal)
        self.animatingButton.titleLabel?.font = UIFont.mediumFont(size: 18)
        self.animatingButton.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupStopButton() {
        self.view.addSubview(self.stopButton)
        self.stopButton.translatesAutoresizingMaskIntoConstraints = false
        let constaints = [
            self.stopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.stopButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.stopButton.widthAnchor.constraint(equalToConstant: 200),
            self.stopButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constaints)
        self.stopButton.setTitle("Stop Animation", for: .normal)
        self.stopButton.backgroundColor = UIColor.red
        self.stopButton.addTarget(
            self,
            action: #selector(stoppButtonTapped),
            for: .touchUpInside
        )
    }
}

extension ButtonAnimationController {

    func animationButtonTapped() {
        self.animatingButton.startAnimating()
    }
    
    func stoppButtonTapped() {
        if self.animatingButton.isAnimating() {
            let isAllowTransition = false
            self.animatingButton.stopAnimating(isAllowTransition: isAllowTransition)
            if isAllowTransition {
                self.animatingButton.finishTransition(withDelay: 0.6, completion: {
                    let sc = SecondController()
                    sc.transitioningDelegate = self
                    self.present(sc, animated: true, completion: nil)
                })
            }
        }
    }
}

extension ButtonAnimationController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FadeTransition(transitionDuration: 0.5, startingAlpha: 1)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
