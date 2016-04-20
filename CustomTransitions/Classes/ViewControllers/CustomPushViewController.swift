//
//  CustomPushViewController.swift
//  CustomTransitions
//
//  Created by Roman Rybachenko on 4/18/16.
//  Copyright © 2016 Roman Rybachenko. All rights reserved.
//

import UIKit

class CustomPushViewController: UIViewController, UINavigationControllerDelegate {
    // MARK: Properties
    let transitionManager = TransitionManager()
    

    // MARK: Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
    }

    
    // MARK: Static func
    static func storyboardIdentifier() -> String {
        return String(self)
    }
    
    
    // MARK: Action funcs
    @IBAction func backBarButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
