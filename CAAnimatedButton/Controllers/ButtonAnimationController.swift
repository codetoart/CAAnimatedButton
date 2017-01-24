//
//  ButtonAnimationController.swift
//  Animations
//
//  Created by Apple on 19/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ButtonAnimationController: UIViewController {

    fileprivate var button = AnimatedButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        setupButton()
        
        self.edgesForExtendedLayout = .bottom
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ButtonAnimationController {
    
    func setupButton() {
        self.view.addSubview(self.button)
        self.button.backgroundColor = UIColor.orange
        self.button.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        self.button.setCornerRadius(radius: 25)
        self.button.setSpinnerColor(color: UIColor.blue)
        self.button.setTitle("Click here", for: .normal)
        self.button.setTitleColor(UIColor.white, for: .normal)
        self.button.titleLabel?.font = UIFont.mediumFont(size: 18)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        let constaints = [
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            self.button.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constaints)
    }
}

extension ButtonAnimationController {
    
    func buttonTapped() {
        self.button.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.button.stopAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { 
                let sc = SecondController()
                sc.transitioningDelegate = self
                self.present(sc, animated: true, completion: nil)
            })
        })
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
