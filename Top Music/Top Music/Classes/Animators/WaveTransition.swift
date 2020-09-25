//
//  WaveTransition.swift
//  Top Music
//
//  Created by Patrick Wilson on 9/18/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

public class WaveTransition: CustomTransition {
    public var sideToSlideFrom: UIRectEdge = .right
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let screen = containerView.bounds
        let size: CGSize = containerView.frame.size
                
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        fromVC.view.originX = fromVC.view.originX - (fromVC.view.frame.width * 0.1)
        }, completion: nil)
                
        var toPath = UIBezierPath()
        let fromPath = UIBezierPath(rect: screen)
        
        if (sideToSlideFrom == .top) {
            toPath = UIBezierPath(rect: CGRect.init(x: 0, y: size.height, width: size.width, height: 0))
        } else if (sideToSlideFrom == .left) {
            toPath = UIBezierPath(rect: CGRect.init(x: size.width, y: 0, width: size.width, height: size.height))
        } else if (sideToSlideFrom == .right) {
            toPath = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: 0, height: size.height))
        } else if (sideToSlideFrom == .bottom) {
            toPath = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: size.width, height: 0))
        }
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = fromPath.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: screen.size.width, height: screen.size.height)
        shapeLayer.position = CGPoint(x: screen.size.width * 0.5, y: screen.size.height * 0.5)
        
        fromVC.view.layer.mask = shapeLayer
        
        let animation: CustomBasicAnimation = CustomBasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = self.duration
        animation.fromValue = fromPath.cgPath
        animation.toValue = toPath.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
        }
        shapeLayer.add(animation, forKey: "path")
    }

}
