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
}

final class AlbumsViewController: UITableViewController {
    
    private var coordinator: AlbumsCoordinator?
    weak var albumsViewControllerDelegate: AlbumsViewControllerDelegate?

    init(coordinator: AlbumsCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.nikeFootball
        configureNavBar()
        configureTableView()
        viewModel?.fetchAlbums()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.deselectSelectedRow()
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
            self.title = viewModel.feedTitle
        } else {
            // empty
        }
    }
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    private func configureTableView() {
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.allowsSelection = true
        
        self.viewModel?.tableView = self.tableView
        self.tableView.delegate = self.viewModel
        self.tableView.dataSource = self.viewModel
        
        self.tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reusableId)
    }

}

extension AlbumsViewController: AlbumsViewModelDelegate {
    func didGetError(_ error: Error) {
        //
    }
    
    func doneRequestingAlbums() {
        // self.activity
        self.tableView.reloadData()
    }
    
}
