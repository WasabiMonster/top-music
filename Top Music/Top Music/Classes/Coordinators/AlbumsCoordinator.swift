//
//  AlbumsCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
import UIKit

class AlbumsCoordinator: Coordinator<DeepLink> {
    
    private var albumDetailCoordinator: AlbumDetailCoordinator?
    
    lazy var albumsViewController: AlbumsViewController = {
        let vc = AlbumsViewController(viewModel: AlbumsViewModel())
        vc.albumsViewControllerDelegate = self
        return vc
    }()
    
    override init(router: RouterProtocol) {
        super.init(router: router)
        router.setRootModule(albumsViewController, hideBar: false)
    }
        
    /* override func start() {
        presenter.pushViewController(albumsVC, animated: true)
    } */
    
    func showDetail(at index: Int) {
        let detailViewModel = AlbumDetailViewModel(detail: albumsViewController.viewModel.album(at: index))
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

extension AlbumsCoordinator: AlbumsViewControllerDelegate {

    func albumsViewController(_ controller: AlbumsViewController, didSelectAlbumAt index: Int) {
        showDetail(at: index)
    }
    
    func albumsViewController(_ viewController: AlbumsViewController, didReceiveError error: Error) {
        albumsViewController.presentErrorAlert(error)
    }
    
}
