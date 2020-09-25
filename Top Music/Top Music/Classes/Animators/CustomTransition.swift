//
//  CustomTransition.swift
//  Top Music
//
//  Created by Patrick Wilson on 9/11/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

class CustomBasicAnimation: CABasicAnimation, CAAnimationDelegate {
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

public class CustomTransition: NSObject {
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
    
    internal func snapshot(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
}

extension CustomTransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}

internal class CustomTransitionNavigationDelegate: NSObject, UINavigationControllerDelegate {
    static let shared = CustomTransitionNavigationDelegate()
    var transitions: [CustomTransition] = []
    var oldNavigationDelegate: UINavigationControllerDelegate?
    
    func pushTransition(_ transition: CustomTransition, forNavigationController navigationController: UINavigationController) {
        transitions.append(transition)
        oldNavigationDelegate = navigationController.delegate
        
        navigationController.delegate = CustomTransitionNavigationDelegate.shared
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = transitions.popLast()
        
        navigationController.delegate = oldNavigationDelegate
        return transition
    }
}

public extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, withCustomTransition transition: CustomTransition) {
        CustomTransitionNavigationDelegate.shared.pushTransition(transition, forNavigationController: self)
        pushViewController(viewController, animated: true)
        print("*091920* \(type(of: self)), \(#function) || PUSH")
    }
    
    func popViewControllerCustomTransition(_ transition: CustomTransition) -> UIViewController? {
        CustomTransitionNavigationDelegate.shared.pushTransition(transition, forNavigationController: self)
        print("*091920* \(type(of: self)), \(#function) || POP")
        return popViewController(animated: true)
    }
}
