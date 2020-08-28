//
//  AlbumsViewModel.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

protocol AlbumsViewModelDelegate: class {
    func didGetError(_ error: Error)
    func doneRequestingAlbums()
}

class AlbumsViewModel: NSObject, BaseViewModel {
    // var didTapBack: (() -> Void)?
    weak var delegate: AlbumsViewModelDelegate?
    var albums: [AlbumModel] = []
    weak var tableView: UITableView?
    
    private func fetchAlbums() {
        let request = Requests.iTunes.topAlbums.init()
        apiManager.execute(request) { result in
            switch result {
            case .success(let response):
                guard let albums = response.results else {
                    self.delegate?.didGetError(ApiError.responseDecodingFailed)
                    return
                }
                
                self.albums = []
                for album in albums {
                    //// let record = AlbumModel(from: <#T##Decoder#>)
                    self.albums.append(album)
                }
                self.delegate?.doneRequestingAlbums()
            case .failure:
                // silent fail
                break
            }
        }
    }
    
    func errorMessage(withError error: Error) -> String {
        // Perform UI updates on main thread
        guard let networkError = error as? ApiError else {
            return error.localizedDescription
        }
        
        var errorMessage = ""
        /* switch networkError {
        case .malformedURL:
            errorMessage = "malformed url"
        case .failedRequest:
            errorMessage = "failed request"
        case .receivedInvalidData:
            errorMessage = "received data is not readable"
        case .failedToStoreCredentials:
            errorMessage = "credentials could not be saved"
        } */
        return errorMessage
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
                          artwork: nil
                          // artwork: album.artworkUrl
                          )
            
            // managePhotoRecordStateForCell(cell, photoDetails: item, indexPath: indexPath)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

/* extension WorkoutHistoryViewModel {
    func managePhotoRecordStateForCell(_ cell: WorkoutCell, photoDetails: WorkoutRecord, indexPath: IndexPath) {
        switch photoDetails.status {
        case .downloaded:
            cell.stopActivityIndicator()
        case .failed:
            cell.stopActivityIndicator()
            cell.textLabel?.text = "Failed to load"
        case .start:
            cell.startActivityIndicator()
            startOperations(for: photoDetails, at: indexPath)
        }
    }
    
    func startOperations(for photoRecord: WorkoutRecord, at indexPath: IndexPath) {
        guard let safeTableView = self.tableView else { return }
        
        if !safeTableView.isDragging && !safeTableView.isDecelerating {
            switch photoRecord.status {
            case .start:
                startDownload(for: photoRecord, at: indexPath)
            case .downloaded:
                reloadRows(at: [indexPath])
            default:
                NSLog("do nothing")
            }
        }
    }
    
    func startDownload(for photoRecord: WorkoutRecord, at indexPath: IndexPath) {
        
        guard PendingOperations.shared.downloadsInProgress[indexPath] == nil else { return }
        
        let downloader = ImageDownloader(photoRecord)
        
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
                let recordToProcess = self.workouts[indexPath.row]
                startOperations(for: recordToProcess, at: indexPath)
            }
        }
    }
}

extension AlbumsViewModel: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
*/
