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
