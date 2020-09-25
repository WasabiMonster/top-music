//
//  UIView+extensions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/28/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    var allSubViews: [UIView] {
        var array = [self.subviews].flatMap {$0}
        array.forEach { array.append(contentsOf: $0.allSubViews) }
        return array
    }
    
    func hideSubviews(_ flag: Bool) {
        self.subviews.forEach { $0.isHidden = flag }
    }
    
    func staggerSlideInContents(side: UIRectEdge, duration: Double = 0.25, delay: Double = 0.0, options: AnimationOptions = .curveEaseIn) {
        if side != .left && side != .right {
            return
        }
        var sDelay: Double = delay
        for vw in allSubViews {
            vw.slideInFromEdge(side: side, duration: duration, delay: delay + sDelay, options: options)
            sDelay = sDelay + 0.1
        }
    }
    
    func slideInFromEdge(side: UIRectEdge, duration: Double = 0.5, delay: Double = 0.0, options: AnimationOptions = .curveEaseIn) {
        let orgXPos = self.originX
        let orgYPos = self.originY
        
        switch side {
        case .right:
            self.originX = self.frame.width + (self.superview?.frame.width ?? 0)
        case .left:
            self.originX = -(self.frame.width)
        case .top:
            self.originY = -(self.frame.height)
        case .bottom:
            self.originY = (self.superview?.frame.height ?? 0) + self.frame.height
        default:
            // no-op
            return
        }
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options,
                       animations: {
                        self.originX = orgXPos
                        self.originY = orgYPos
        }, completion: nil)
    }
    
    var originX: CGFloat {
        set {
            var frame:CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }

    var originY: CGFloat {
        set {
            var frame:CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }

    func setWidth(_ width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }

    func setHeight(_ height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    func addSubviews(_ svArr:[UIView], manualConstraints: Bool = true) {
        for vw in svArr {
            self.addSubview(vw)
            vw.translatesAutoresizingMaskIntoConstraints = !manualConstraints
        }
    }
    
    func fadeInFromOut(speed: Double = 0.35, delay: Double = 0.3) {
        self.alpha = 0
        UIView.animate(withDuration: speed, delay: delay, options: .curveEaseOut, animations: {() -> Void in
            self.alpha = 1.0
        }, completion: nil)
    }
    
}
