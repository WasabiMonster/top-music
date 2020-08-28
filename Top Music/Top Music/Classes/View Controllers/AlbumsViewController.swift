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

final class AlbumsViewController: UITableViewController {
    
    private var coordinator: AlbumsCoordinator?
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
        
        self.view.backgroundColor = UIColor.nikeFootball
        configureTableView()
        // viewModelClosures()
        viewModel?.fetchAlbums()
    }
    
    var viewModel: AlbumsViewModel? {
        willSet {
            viewModel?.delegate = nil
        }
        didSet {
            viewModel?.delegate = self
            updateDisplay()
        }
    }
    
    private func updateDisplay() {
        if let viewModel = viewModel {
            // genreLabel.text = "temp genre"
            // releaseDateLabel.text = "01/01/1976"
        } else {
            // genreLabel.text = ""
            // releaseDateLabel.text = ""
        }
    }
    
    private func configureTableView() {
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.allowsSelection = true
        
        self.tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reusableId)
    }

}

extension AlbumsViewController: AlbumsViewModelDelegate {
    func didGetError(_ error: Error) {
        //
    }
    
    func doneRequestingAlbums() {
        self.tableView.reloadData()
    }
    
}
