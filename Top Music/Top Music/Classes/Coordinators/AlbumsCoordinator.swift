//
//  AlbumsCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

class AlbumsCoordinator: BaseCoordinator {
    var albumDetailCoordinator: AlbumDetailCoordinator?
    
    private var albumsViewController: AlbumsViewController?
    
    override init(presenter: UINavigationController) {
        super.init(presenter: presenter)
        
    }
        
    override func start() {
        // These can eventually be created using a Factory pattern for
        // cleaner creation and lighter coordinators
        let albumsViewController = AlbumsViewController(coordinator: self)
        albumsViewController.albumsViewControllerDelegate = self
        albumsViewController.viewModel = AlbumsViewModel()
        presenter.pushViewController(albumsViewController, animated: true)
    }
        
}

extension AlbumsCoordinator: AlbumsViewControllerDelegate {

    func albumsViewController(_ controller: AlbumsViewController, didSelectAlbumAt index: Int) {
        let tempViewModel = AlbumDetailViewModel()
        let albumDetailCoordinator = AlbumDetailCoordinator(presenter: presenter, viewModel: tempViewModel)
        //// albumDetailCoordinator.delegate = self
        self.albumDetailCoordinator = albumDetailCoordinator
        albumDetailCoordinator.start()
    }
    
}

/* extension AlbumsCoordinator: AlbumDetailCoordinatorDelegate {
    
    func albumDetailCoordinatorDidFinish(detailCoordinator: AlbumDetailCoordinator) {
        self.albumDetailCoordinator = nil
        window.rootViewController = albumsViewController
    }
    
} */

/* extension AlbumsCoordinator: AlbumsViewModelCoordinatorDelegate {
    func albumsViewModelDidSelectData(_ viewModel: AlbumsViewModel, data: DataItem) {
        albumDetailCoordinator = AlbumDetailCoordinator(dataItem: data)
        albumDetailCoordinator?.delegate = self
        albumDetailCoordinator?.start()
    }
} */
