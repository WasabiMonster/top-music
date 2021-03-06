//
//  AlbumsCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
import UIKit

class AlbumsCoordinator: BaseCoordinator {
    
    private var albumDetailCoordinator: AlbumDetailCoordinator?
    private var albumsViewController: AlbumsViewController?

    override init(presenter: UINavigationController) {
        super.init(presenter: presenter)
        
    }
        
    override func start() {
        // These can eventually be created using a Factory pattern for
        // cleaner creation and lighter coordinators
        let albumsVC = AlbumsViewController()
        albumsVC.viewModel = AlbumsViewModel()
        albumsVC.albumsViewControllerDelegate = self
        self.albumsViewController = albumsVC
        presenter.pushViewController(albumsVC, animated: true)
    }
    
    func showDetail(at index: Int) {
        let detailViewModel = AlbumDetailViewModel()
        detailViewModel.detail = albumsViewController?.viewModel?.album(at: index)
        let albumDC = AlbumDetailCoordinator(presenter: presenter, viewModel: detailViewModel)
        self.albumDetailCoordinator = albumDC
        albumDC.start()
    }
        
}

extension AlbumsCoordinator: AlbumsViewControllerDelegate {

    func albumsViewController(_ controller: AlbumsViewController, didSelectAlbumAt index: Int) {
        showDetail(at: index)
    }
    
    func albumsViewController(_ viewController: AlbumsViewController, didReceiveError error: Error) {
        albumsViewController?.presentErrorAlert(error)
    }
    
}
