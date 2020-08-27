//
//  AppCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
        
        navigationController.navigationBar.isHidden = true
    }
    
    override func start() {
        window.makeKeyAndVisible()
    }
    
    func showHome() {
        guard window.rootViewController == nil else { return }
        
    }
    
    func showDetail() {
        
    }
}
