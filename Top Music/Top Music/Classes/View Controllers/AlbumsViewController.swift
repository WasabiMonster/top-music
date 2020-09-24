//
//  ViewController.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

protocol AlbumsViewControllerDelegate: class {
    func albumsViewController(_ controller: AlbumsViewController, didSelectAlbumAt index: Int)
    func albumsViewController(_ viewController: AlbumsViewController, didReceiveError error: Error)
}

final class AlbumsViewController: UITableViewController {
    
    let viewModel: AlbumsViewModel
    let tableViewDelegate: AlbumsTableViewDelegate
    weak var albumsViewControllerDelegate: AlbumsViewControllerDelegate?

    init(viewModel: AlbumsViewModel) {
        self.viewModel = viewModel
        self.tableViewDelegate = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.nikeFootball
        self.refreshControl = UIRefreshControl()
        configureTableView()
        configureActions()
        viewModel.fetchAlbums()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    private func configureTableView() {
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.allowsSelection = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self.viewModel
        self.tableView.prefetchDataSource = self.viewModel
        
        self.tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reusableId)
        
        self.tableView.showActivityIndicator()
    }
    
    private func configureActions() {
        self.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.viewModel.fetchAlbums()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate.albumsTableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate.albumsTableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        albumsViewControllerDelegate?.albumsViewController(self, didSelectAlbumAt: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

extension AlbumsViewController: AlbumsViewModelDelegate {
    func didReceiveError(_ error: Error) {
        self.albumsViewControllerDelegate?.albumsViewController(self, didReceiveError: error)
    }
    
    func doneRequestingAlbums() {
        DispatchQueue.main.async {
            self.tableView.hideActivityIndicator()
            self.title = self.viewModel.feedTitle
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
        
}
