//
//  WaveTransition.swift
//  Top Music
//
//  Created by Patrick Wilson on 9/11/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

class WaveBasicAnimation: CABasicAnimation, CAAnimationDelegate {
    public var onFinish: (() -> (Void))?
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let onFinish = onFinish {
            onFinish()
        }
    }   
}

public class WaveTransition: NSObject {
    public var duration: TimeInterval = 0.33
    required public init(duration: TimeInterval? = nil) {
        super.init()
        self.duration = duration ?? defaultDuration()
    }
    
    func defaultDuration() -> TimeInterval {
        return 0.33
    }
    
    internal static func rectMovedIn(_ rect: CGRect, magnitude: CGFloat) -> CGRect {
        return CGRect.init(x: rect.origin.x + magnitude, y: rect.origin.y + magnitude, width: rect.size.width - magnitude * 2, height: rect.size.height - magnitude * 2)
    }
    
    /* internal func snapshot(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    } */
}

extension WaveTransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}

internal class WaveTransitionNavigationDelegate: NSObject, UINavigationControllerDelegate {
    static let shared = WaveTransitionNavigationDelegate()
    var transitions: [WaveTransition] = []
    var oldNavigationDelegate: UINavigationControllerDelegate?
    
    func pushTransition(_ transition: WaveTransition, forNavigationController navigationController: UINavigationController) {
        transitions.append(transition)
        oldNavigationDelegate = navigationController.delegate
        
        navigationController.delegate = WaveTransitionNavigationDelegate.shared
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = transitions.popLast()
        
        navigationController.delegate = oldNavigationDelegate
        
        return transition
    }
}

public extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, withWaveTransition transition: WaveTransition) {
        WaveTransitionNavigationDelegate.shared.pushTransition(transition, forNavigationController: self)
        pushViewController(viewController, animated: true)
        print("*091920* \(type(of: self)), \(#function) || PUSH")
    }
    
    func popViewControllerWaveTransition(_ transition: WaveTransition) -> UIViewController? {
        WaveTransitionNavigationDelegate.shared.pushTransition(transition, forNavigationController: self)
        return popViewController(animated: true)
    }
}
