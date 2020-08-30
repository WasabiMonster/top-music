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
    private let window: UIWindow
    private let rootViewController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.isHidden = false
        rootViewController.navigationBar.prefersLargeTitles = true
        super.init(presenter: rootViewController)
    }
    
    override func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        showHome()
    }
    
    func showHome() {
        self.removeChildCoordinators()
        
        let albumsCoordinator = AlbumsCoordinator(presenter: rootViewController)
        albumsCoordinator.start()
    }
    
}
