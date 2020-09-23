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
    let albumsViewModel: AlbumsViewModel = AlbumsViewModel()
    
    lazy var albumsViewController: AlbumsViewController = {
        let vc = AlbumsViewController(viewModel: albumsViewModel)
        return vc
    }()
    
    override init(router: RouterProtocol) {
        super.init(router: router)
        router.setRootModule(albumsViewController, hideBar: false)
    }
        
    /* override func start() {
        presenter.pushViewController(albumsVC, animated: true)
    } */
    
}
