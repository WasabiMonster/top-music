//
//  UIFont+TopMusicAdditions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static var header: UIFont {
        guard let font = UIFont(name: "Geomanist-Bold", size: 17.0) else { return UIFont.preferredFont(forTextStyle: .headline) }
        return font
    }
    
    static func customBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Geomanist-Bold", size: size) else { return UIFont.preferredFont(forTextStyle: .headline) }
        return font
    }
    
    static func customBody(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Geomanist-Book", size: size) else { return UIFont.preferredFont(forTextStyle: .subheadline) }
        return font
    }
    
    static func customRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Geomanist-Regular", size: size) else { return UIFont.preferredFont(forTextStyle: .body) }
        return font
    }
    
    static func customMedium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Geomanist-Medium", size: size) else { return UIFont.preferredFont(forTextStyle: .body) }
        return font
    }
    
}
