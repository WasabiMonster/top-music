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
        rootViewController.navigationBar.barStyle = .black
        super.init(presenter: rootViewController)
    }
    
    override func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        showHome()
    }
    
    func showHome() {
        // guard window.rootViewController == nil else { return }
        let albumsCoordinator = AlbumsCoordinator(presenter: rootViewController)
        albumsCoordinator.start()
    }
}
