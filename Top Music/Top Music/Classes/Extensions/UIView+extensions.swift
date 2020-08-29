//
//  UIView+extensions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/28/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(_ svArr:[UIView]) {
        for vw in svArr {
            self.addSubview(vw)
            vw.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}
