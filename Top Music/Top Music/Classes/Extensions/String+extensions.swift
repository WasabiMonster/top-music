//
//  String+extensions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

// Convenience method for creating URL from a string
public extension String {
    var toURL: URL? {
        return URL(string: self)
    }
}
