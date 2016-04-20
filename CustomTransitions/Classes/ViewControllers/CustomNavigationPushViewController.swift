//
//  CustomNavigationPushViewController.swift
//  CustomTransitions
//
//  Created by Roman Rybachenko on 4/20/16.
//  Copyright © 2016 Roman Rybachenko. All rights reserved.
//

import UIKit

class CustomNavigationPushViewController: UIViewController, UINavigationControllerDelegate {
    // MARK: Properties
    let transitionManager = TransitionManager()
    
    // MARK: Override funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: Static func
    
    static func storyboardIdentifier() -> String {
        return String(self)
    }

    // MARK: -UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController,
                              animationControllerForOperation operation: UINavigationControllerOperation,
                              fromViewController fromVC: UIViewController,
                              toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transitionManager.reverse = operation == .Pop
        return transitionManager
    }

}
