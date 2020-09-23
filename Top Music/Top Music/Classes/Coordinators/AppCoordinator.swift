//
//  AppCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator<DeepLink> {
    private let navigationController: UINavigationController
    
    lazy var albumsCoordinator: AlbumsCoordinator = {
        let router = Router(navigationController: navigationController)
        let coordinator = AlbumsCoordinator(router: router)
        return coordinator
    }()
    
    override init(router: RouterProtocol) {
        navigationController = router.navigationController
        super.init(router: router)

        // router.setRootModule(albumsCoordinator.albumsViewController, hideBar: true)
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationController.navigationBar.isHidden = false
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)
        ]
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        navigationController.navigationBar.barTintColor = UIColor.nikeFootball
        navigationController.navigationBar.tintColor = UIColor.groovyPink
    }
    
    override func start() {
        showHome()
    }
    
    func showHome() {
        albumsCoordinator.start()
    }
    
}
