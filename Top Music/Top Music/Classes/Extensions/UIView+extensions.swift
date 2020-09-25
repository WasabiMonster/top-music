//
//  UIView+extensions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/28/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    /* public enum ScreenEdge {
        case top
        case left
        case bottom
        case right
    } */
    
    var allSubViews: [UIView] {
        var array = [self.subviews].flatMap {$0}
        array.forEach { array.append(contentsOf: $0.allSubViews) }
        return array
    }
    
    func animateFromEdge(_ side:NSLayoutConstraint, duration: Double = 0.5, delay: Double = 0.0) {
        // self.topAnchor
        // self.leftAnchor
        
        // self.topConstraint.constant += 100
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseIn,
                       animations: {
                        
                        self.layoutIfNeeded()
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
    
    func fadeInFromOut() {
        self.alpha = 0
        UIView.animate(withDuration: 0.35, delay: 0.3, options: .curveEaseOut, animations: {() -> Void in
            self.alpha = 1.0
        }, completion: nil)
    }
    
}
