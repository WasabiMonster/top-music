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
        
    weak var albumsViewControllerDelegate: AlbumsViewControllerDelegate?
    weak var tableViewDelegate: AlbumsTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.nikeFootball
        configureTableView()
        viewModel?.fetchAlbums()
        self.refreshControl = UIRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.deselectSelectedRow()
    }
        
    var viewModel: AlbumsViewModel? {
        willSet {
            viewModel?.delegate = nil
            self.tableViewDelegate = nil
        }
        didSet {
            viewModel?.delegate = self
            self.tableViewDelegate = viewModel
        }
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate?.albumsTableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate?.albumsTableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        albumsViewControllerDelegate?.albumsViewController(self, didSelectAlbumAt: indexPath.row)
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

extension AlbumsViewController: AlbumsViewModelDelegate {
    func didGetError(_ error: Error) {
        self.albumsViewControllerDelegate?.albumsViewController(self, didReceiveError: error)
    }
    
    func doneRequestingAlbums() {
        self.tableView.hideActivityIndicator()
        self.title = viewModel?.feedTitle
        self.tableView.reloadData()
    }
        
}
