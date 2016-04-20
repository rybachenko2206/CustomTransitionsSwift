//
//  TransitionManager.swift
//  CustomTransitions
//
//  Created by Roman Rybachenko on 4/18/16.
//  Copyright © 2016 Roman Rybachenko. All rights reserved.
//


enum TransitionType: Int {
    case Push
    case PresentModal
    case PresentModalDynamic
    case CustomPush
    case Pop
    case DismissModal
    case DismissModalDynamic
    case CustomPop
    
    func simpleDescription() -> String {
        switch self {
        case .Push,
             .Pop,
             .PresentModal,
             .DismissModal,
             .PresentModalDynamic,
             .DismissModalDynamic,
             .CustomPush,
             .CustomPop:
            
            return String(self)
        }
    }
    
    static func backTypeForType(type: TransitionType) -> TransitionType? {
        var returnType: TransitionType?
        switch type {
            case .Push:
                returnType = .Pop
            case .PresentModal:
                returnType = .DismissModal
            case .PresentModalDynamic:
                returnType = .DismissModalDynamic
            case .CustomPush:
                returnType = .CustomPop
            default:
                returnType = nil;
        }
        return returnType
    }
}


import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: Constants
    let presentModalDuration = 0.5
    let presentModalDynamicDuration = 1.5
    let presentPushDuration = 0.35
    let presentCustomPushDuration = 1.5
    let pushBottomViewOffset: CGFloat = -150.0

    // MARK: Properties
    var transitionType: TransitionType!
    var reverse: Bool = false
    

    // MARK: Delegate funcs:
    // MARK: -UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        var duration = 0.0
        switch transitionType! {
            case .Push,
                 .Pop:
                duration = presentPushDuration
            case .PresentModal,
                 .DismissModal:
                duration = presentModalDuration
            case .PresentModalDynamic,
                 .DismissModalDynamic:
                duration = presentModalDynamicDuration
            case .CustomPush,
                 .CustomPop:
                duration = presentCustomPushDuration
        }
        
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType! {
            case .PresentModal:
                animatePresentModal(transitionContext)
            case .PresentModalDynamic:
                animatePresentModalDynamic(transitionContext)
            case .DismissModal,
                 .DismissModalDynamic:
                animateDismissModal(transitionContext)
            case .Push:
                animatePush(transitionContext)
            case .Pop:
                animatePop(transitionContext)
            case .CustomPush,
                 .CustomPop:
                animateCustomPushPop(transitionContext)
        }
    }
    
    
    // MARK: Private funcs
    
    private func animatePresentModal(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        let bounds = UIScreen.mainScreen().bounds
        
        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height)
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
                                   animations: {() -> Void in
                                    
            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC
            
            }, completion: {(finished) -> Void in
                
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
        })
    }
    
    private func animateDismissModal(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        
        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.7
        
        fromViewController.view.frame = finalFrameForVC
        
        containerView?.addSubview(toViewController.view)
        containerView?.sendSubviewToBack(toViewController.view)
        
        
        var finalFrameFromVc = UIScreen.mainScreen().bounds
        finalFrameFromVc.origin.y = finalFrameFromVc.size.height
        
        UIView.animateWithDuration(presentModalDuration,
                                   animations: {() -> Void in
                                    
            fromViewController.view.frame = finalFrameFromVc
            toViewController.view.alpha = 1.0
                                    
                                }, completion: {(finished) -> Void in
                
            transitionContext.completeTransition(true)
        })
    }
    
    
    private func animatePresentModalDynamic(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        let bounds = UIScreen.mainScreen().bounds
        
        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height)
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(presentModalDynamicDuration,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.0,
                                   options: .CurveLinear,
                                   animations: {() -> Void in
                                    
                                    fromViewController.view.alpha = 0.5
                                    toViewController.view.frame = finalFrameForVC
                                    
            }, completion: {(finished) -> Void in
                
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
                
        })
    }
    
    
    private func animatePush(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toVcFinalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        
        containerView!.addSubview(toViewController.view)
        
        let bounds = UIScreen.mainScreen().bounds
        
        var fromVcFinishFrame = bounds
        fromVcFinishFrame.origin.x = pushBottomViewOffset
        
        let toVcStartFrame = CGRectMake(bounds.size.width, 0, bounds.size.width, bounds.size.height)
        toViewController.view.frame = toVcStartFrame
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(presentPushDuration,
                                   animations: {() -> Void in
            
                fromViewController.view.frame = fromVcFinishFrame
                toViewController.view.frame = toVcFinalFrame
            
            }, completion: {(finished) -> Void in
                
                transitionContext.completeTransition(true)
        })
    }
    
    private func animatePop(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        
        var endFrameFromVC = UIScreen.mainScreen().bounds
        endFrameFromVC.origin.x = endFrameFromVC.size.width
        
        var startFrameToVC = UIScreen.mainScreen().bounds
        startFrameToVC.origin.x = pushBottomViewOffset
        toViewController.view.frame = startFrameToVC
        
        containerView!.addSubview(toViewController.view)
        containerView!.sendSubviewToBack(toViewController.view)
        
        UIView.animateWithDuration(presentPushDuration,
                                   animations: {() -> Void in
            
                fromViewController.view.frame = endFrameFromVC
                toViewController.view.frame = finalFrameForVC
            
            }, completion: {(finished) -> Void in
                
                transitionContext.completeTransition(true)
        })
    }
    
    private func animateCustomPushPop(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toView = toViewController.view
        let fromView = fromViewController.view
        let direction: CGFloat = reverse ? -1 : 1
        let const: CGFloat = -0.005
        
        toView.layer.anchorPoint = CGPointMake(direction == 1 ? 0 : 1, 0.5)
        fromView.layer.anchorPoint = CGPointMake(direction == 1 ? 1 : 0, 0.5)
        
        var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
        var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
        viewFromTransform.m34 = const
        viewToTransform.m34 = const
        
        containerView!.transform = CGAffineTransformMakeTranslation(direction * containerView!.frame.size.width / 2.0, 0)
        toView.layer.transform = viewToTransform
        containerView!.addSubview(toView)
        
        UIView.animateWithDuration(presentCustomPushDuration,
                                   animations: {
                                    
                  containerView!.transform = CGAffineTransformMakeTranslation(-direction * containerView!.frame.size.width / 2.0, 0)
                  fromView.layer.transform = viewFromTransform
                  toView.layer.transform = CATransform3DIdentity
                                    
            }, completion: {(finished) -> Void in
                
                containerView!.transform = CGAffineTransformIdentity
                fromView.layer.transform = CATransform3DIdentity
                toView.layer.transform = CATransform3DIdentity
                fromView.layer.anchorPoint = CGPointMake(0.5, 0.5)
                toView.layer.anchorPoint = CGPointMake(0.5, 0.5)
                
                if (transitionContext.transitionWasCancelled()) {
                    toView.removeFromSuperview()
                } else {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    
    
}
