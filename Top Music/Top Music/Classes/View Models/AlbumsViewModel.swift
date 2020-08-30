//
//  AlbumsViewModel.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
import UIKit

protocol AlbumsViewModelDelegate: class {
    func didGetError(_ error: Error)
    func doneRequestingAlbums()
}

class AlbumsViewModel: NSObject, BaseViewModel {
    weak var delegate: AlbumsViewModelDelegate?
    private var feedResponse: AlbumFeedResponse?
    private var albums: [AlbumModel] = []
    weak var tableView: UITableView?
    
    var feedTitle: String {
        return "\(feedResponse?.author.name ?? "") \(feedResponse?.title ?? "")"
    }
    
    var numberOfAlbums: Int {
        return albums.count
    }
    
    func album(at index: Int) -> AlbumModel {
        return albums[index]
    }
    
    func fetchAlbums() {
        let request = Requests.iTunes.topAlbums.init()
        apiManager.execute(request) { result in
            switch result {
            case .success(let response):
                guard let albums = response.results else {
                    self.delegate?.didGetError(ApiError.responseDecodingFailed)
                    return
                }
                self.feedResponse = response
                self.albums = []
                for album in albums {
                    self.albums.append(album)
                }
                self.delegate?.doneRequestingAlbums()
            case .failure:
                // silent fail
                break
            }
        }
    }
    
}

extension AlbumsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.reusableId) as? AlbumCell {
            cell.addActivityIndicator()
            
            let album = albums[indexPath.row]
            cell.populate(artist: album.artistName,
                          album: album.name,
                          artwork: album.image
                          )
            
            manageAlbumImageStateForCell(cell, albumDetails: album, indexPath: indexPath)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension AlbumsViewModel: UITableViewDelegate {
    func manageAlbumImageStateForCell(_ cell: AlbumCell, albumDetails: AlbumModel, indexPath: IndexPath) {
        switch albumDetails.imageStatus {
        case .downloaded:
            cell.stopActivityIndicator()
        case .failed:
            cell.stopActivityIndicator()
            // cell.textLabel?.text = "Failed to load"
        case .start:
            cell.startActivityIndicator()
            startOperations(for: albumDetails, at: indexPath)
        }
    }
    
    func startOperations(for albumModel: AlbumModel, at indexPath: IndexPath) {
        guard let tableView = self.tableView else { return }
        
        if !tableView.isDragging && !tableView.isDecelerating {
            switch albumModel.imageStatus {
            case .start:
                startDownload(for: albumModel, at: indexPath)
            case .downloaded:
                reloadRows(at: [indexPath])
            default:
                NSLog("do nothing")
            }
        }
    }
    
    func startDownload(for albumModel: AlbumModel, at indexPath: IndexPath) {
        guard PendingOperations.shared.downloadsInProgress[indexPath] == nil else { return }
        
        let downloader = ImageDownloader(albumModel)
        downloader.completionBlock = {
            if downloader.isCancelled { return }
            
            DispatchQueue.main.async {
                PendingOperations.shared.downloadsInProgress.removeValue(forKey: indexPath)
                self.reloadRows(at: [indexPath])
            }
        }
        
        PendingOperations.shared.downloadsInProgress[indexPath] = downloader
        PendingOperations.shared.addOperation(downloader)
    }
    
    func reloadRows(at indexPath: [IndexPath]) {
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            self.tableView?.beginUpdates()
            self.tableView?.reloadRows(at: indexPath, with: .fade)
            self.tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func loadImagesForOnscreenCells() {
        if let pathsArray = self.tableView?.indexPathsForVisibleRows {
            
            let allPendingOperations = Set(PendingOperations.shared.downloadsInProgress.keys)
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            
            toBeCancelled.subtract(visiblePaths)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = PendingOperations.shared.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                
                PendingOperations.shared.downloadsInProgress.removeValue(forKey: indexPath)
            }
            
            for indexPath in toBeStarted {
                let recordToProcess = self.albums[indexPath.row]
                startOperations(for: recordToProcess, at: indexPath)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        PendingOperations.shared.suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            PendingOperations.shared.resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        PendingOperations.shared.resumeAllOperations()
    }
    
}
