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
        coordinator.albumsViewController.albumsViewControllerDelegate = self
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
    
    override func start(with link: DeepLink?) {
        if let link = link {
            switch link {
            case .home:
                showHome()
            case .detail:
                showDetail(at: 0)
            }
        } else {
            showHome()
        }
    }
    
    func showHome() {
        albumsCoordinator.start()
    }
    
    func showDetail(at index: Int) {
        let detailViewModel = AlbumDetailViewModel(detail: albumsCoordinator.albumsViewModel.album(at: index))
        let coordinator = AlbumDetailCoordinator(router: router, viewModel: detailViewModel)
        
        // Maintain a strong reference to avoid deallocation
        addChild(coordinator)
        coordinator.start()
        
        // Avoid retain cycles and don't forget to remove the child when popped
        router.push(coordinator, animated: true) { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
        
        /* let detailViewModel = AlbumDetailViewModel()
        detailViewModel.detail = albumsViewController?.viewModel?.album(at: index)
        let albumDC = AlbumDetailCoordinator(presenter: presenter, viewModel: detailViewModel)
        self.albumDetailCoordinator = albumDC
        albumDC.start() */
    }
    
}

extension AppCoordinator: AlbumsViewControllerDelegate {

    func albumsViewController(_ controller: AlbumsViewController, didSelectAlbumAt index: Int) {
        showDetail(at: index)
    }
    
    func albumsViewController(_ viewController: AlbumsViewController, didReceiveError error: Error) {
        viewController.presentErrorAlert(error)
    }
    
}
