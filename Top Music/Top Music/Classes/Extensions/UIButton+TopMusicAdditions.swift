//
//  UIButton+TopMusicAdditions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/29/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

extension UIButton {
    
    static func callToAction(text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.tintColor = .offWhite
        button.accessibilityLabel = text
        button.backgroundColor = UIColor.nikeFootball
        button.layer.cornerRadius = 6
        
        return button
    }
    
}
