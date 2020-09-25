//
//  Presentable.swift
//  Top Music
//
//  Created by Patrick Wilson on 9/19/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

public protocol Presentable {
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}
