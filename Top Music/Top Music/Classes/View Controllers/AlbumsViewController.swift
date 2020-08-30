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
}

final class AlbumsViewController: UITableViewController {
    
    weak var albumsViewControllerDelegate: AlbumsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.view.backgroundColor = UIColor.nikeFootball
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
        }
    }
        
    private func configureTableView() {
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.allowsSelection = true
        
        self.viewModel?.tableView = self.tableView
        //// self.tableView.delegate = self.viewModel
        self.tableView.dataSource = self.viewModel
        self.tableView.prefetchDataSource = self.viewModel
        
        self.tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reusableId)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel?.tableViewDelegate?.albumsTableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel?.tableViewDelegate?.albumsTableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        albumsViewControllerDelegate?.albumsViewController(self, didSelectAlbumAt: indexPath.row)
    }
    
}

extension AlbumsViewController: AlbumsViewModelDelegate {
    func didGetError(_ error: Error) {
        //
    }
    
    func doneRequestingAlbums() {
        // self.activity
        self.title = viewModel?.feedTitle
        self.tableView.reloadData()
    }
        
}
