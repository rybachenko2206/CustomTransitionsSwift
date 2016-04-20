//
//  CustomPresentViewController.swift
//  CustomTransitions
//
//  Created by Roman Rybachenko on 4/18/16.
//  Copyright © 2016 Roman Rybachenko. All rights reserved.
//

import UIKit

class CustomPresentViewController: UIViewController {
    
    // MARK: Override funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: Static func
    
    static func storyboardIdentifier() -> String {
        return String(self)
    }

    
    // MARK: Action funcs
    
    @IBAction func closeBarButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
