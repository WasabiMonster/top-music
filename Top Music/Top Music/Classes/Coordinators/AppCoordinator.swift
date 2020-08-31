//
//  AppCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private var albumsCoordinator: AlbumsCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        super.init(presenter: rootViewController)
        configureNavBar()
    }
    
    private func configureNavBar() {
        rootViewController.navigationBar.isHidden = false
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)
        ]
        rootViewController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        rootViewController.navigationBar.barTintColor = UIColor.nikeFootball
        rootViewController.navigationBar.tintColor = UIColor.groovyPink
    }
    
    override func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        albumsCoordinator = AlbumsCoordinator(presenter: rootViewController)
        showHome()
    }
    
    func showHome() {
        albumsCoordinator?.start()
    }
    
}
