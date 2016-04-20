//
//  HomeViewController.swift
//  CustomTransitions
//
//  Created by Roman Rybachenko on 4/18/16.
//  Copyright © 2016 Roman Rybachenko. All rights reserved.
//


import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    let defCellIdentifier = "DefaultCell"
    var transitinsList: [TransitionType]!
    let transitionManager = TransitionManager()
    var selectedType: TransitionType?

    
    // MARK: Override funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationController?.delegate = self

        transitinsList = [.Push, .PresentModal, .PresentModalDynamic, .CustomPush]
    }
    
    
    // MARK: Delegate funcs:
    // MARK: -UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transitinsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(defCellIdentifier, forIndexPath: indexPath)
        let trType = transitinsList[indexPath.row];
        let typeStr = trType.simpleDescription()
        let titleStr = "Custom Transition" + " " + typeStr
        cell.textLabel?.text = titleStr
        
        return cell
    }

    
    // MARK: -UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let type = TransitionType(rawValue:indexPath.row) {
            selectedType = type
            performTransitionForType(selectedType!)
        } else {
            print("Create TransitionType error");
        }
    }
    
    
    // MARK: -UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionManager.transitionType = selectedType!
        return transitionManager
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionManager.transitionType = TransitionType.backTypeForType(selectedType!)
        return transitionManager
    }
    
    
    // MARK: -UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController,
                              animationControllerForOperation operation: UINavigationControllerOperation,
                              fromViewController fromVC: UIViewController,
                              toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transitionManager.reverse = operation == .Pop
        transitionManager.transitionType = .CustomPush
        return transitionManager
    }
    
    
    // MARK: Private funcs
    
    
    
    private func performTransitionForType(type: TransitionType) {
        switch type {
            case .PresentModal,
                 .PresentModalDynamic:
                performCustomPresent()
            case .Push:
                performCustomPush()
            case .CustomPush:
                performCustomNavigationPush()
        default:
            break
        }
    }
    
    private func performCustomPush() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customPushVC = storyboard.instantiateViewControllerWithIdentifier(CustomPushViewController.storyboardIdentifier())
        customPushVC.transitioningDelegate = self;
        presentViewController(customPushVC, animated: true, completion: nil)
    }
    
    private func performCustomNavigationPush() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customPushVC = storyboard.instantiateViewControllerWithIdentifier(CustomNavigationPushViewController.storyboardIdentifier())
//        presentViewController(customPushVC, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(customPushVC, animated: true)
    }
    
    private func performCustomPresent() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customPresentVC = storyboard.instantiateViewControllerWithIdentifier(CustomPresentViewController.storyboardIdentifier())
        customPresentVC.transitioningDelegate = self
        presentViewController(customPresentVC, animated: true, completion: nil)
    }
}
