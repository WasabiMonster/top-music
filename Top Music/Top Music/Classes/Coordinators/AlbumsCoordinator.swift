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

    override init(presenter: UINavigationController) {
        super.init(presenter: presenter)
        
    }
        
    override func start() {
        // These can eventually be created using a Factory pattern for
        // cleaner creation and lighter coordinators
        let albumsViewController = AlbumsViewController()
        albumsViewController.albumsViewControllerDelegate = self
        albumsViewController.viewModel = AlbumsViewModel()
        presenter.pushViewController(albumsViewController, animated: true)
    }
    
    func showDetail(at index: Int) {
        self.removeChildCoordinators()
        
        let detailViewModel = AlbumDetailViewModel()
        /// detailViewModel.model = AlbumModel(from: <#Decoder#>)
        let albumDetailCoordinator = AlbumDetailCoordinator(presenter: presenter, viewModel: detailViewModel)
        albumDetailCoordinator.start()
    }
        
}

extension AlbumsCoordinator: AlbumsViewControllerDelegate {

    func albumsViewController(_ controller: AlbumsViewController, didSelectAlbumAt index: Int) {
        showDetail(at: index)
    }
    
}
