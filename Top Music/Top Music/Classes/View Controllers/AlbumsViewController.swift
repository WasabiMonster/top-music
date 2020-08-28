//
//  ViewController.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

protocol AlbumsViewControllerDelegate: class {
    func albumsViewController(_ controller: AlbumsViewController, didSelectAlbumAt index: Int)
    // didReceiveError
}

final class AlbumsViewController: UIViewController {
    
    private var coordinator: AlbumsCoordinator?
    private var viewModel: AlbumsViewModel
    weak var albumsViewControllerDelegate: AlbumsViewControllerDelegate?

    init(coordinator: AlbumsCoordinator, viewModel: AlbumsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

