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

protocol AlbumsTableViewDelegate: class {
    func albumsTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func albumsTableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

final class AlbumsViewModel: NSObject {
    weak var delegate: AlbumsViewModelDelegate?
    private var feedResponse: AlbumFeedResponse?
    internal var albums: [AlbumModel] = []
    fileprivate lazy var imageStore = ImageLoader()
    fileprivate lazy var loadingQueue = OperationQueue()
    fileprivate lazy var loadingOperations = [IndexPath: ImageLoadOperation]()
    fileprivate var viewedIndexPaths = [IndexPath]()
    
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
                self.imageStore.imagesData = self.albums
                self.delegate?.doneRequestingAlbums()
            case .failure(let error):
                self.delegate?.didGetError(error)
                break
            }
        }
    }
}

extension AlbumsViewModel: AlbumsTableViewDelegate {
    
    func albumsTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AlbumCell else { return }
        
        var shouldFade = false
        if !viewedIndexPaths.contains(indexPath) {
            viewedIndexPaths.append(indexPath)
            shouldFade = true
        }
        
        // Closure describing how to update the cell once the image has loaded
        let updateCellClosure: (UIImage?) -> () = { [unowned self] (image) in
            cell.updateImage(image, shouldFade: shouldFade)
            self.loadingOperations.removeValue(forKey: indexPath)
        }
        
        // Check for existing image loader
        if let imageLoader = loadingOperations[indexPath] {
            // Check if it's been loaded yet
            if let image = imageLoader.image {
                cell.updateImage(image, shouldFade: shouldFade)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                // Image not loaded yet. Set completion handler for when it arrives
                imageLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            // Create an imageloader for this index path
            if let imageLoader = imageStore.loadImage(at: indexPath.row) {
                // Begin loading operation with a completion handler
                imageLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(imageLoader)
                loadingOperations[indexPath] = imageLoader
            }
        }
    }
    
    func albumsTableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // If there's an image loader for this index path we don't need it any more. Cancel and dispose
        if let imageLoader = loadingOperations[indexPath] {
            imageLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
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
            cell.index = indexPath[1]
            cell.populate(artist: album.artistName, album: album.name)
            cell.updateImage(.none, shouldFade: false)
            return cell
        }
        return UITableViewCell()
    }
        
}

extension AlbumsViewModel: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] { return }
            if let imageLoader = imageStore.loadImage(at: indexPath.row) {
                loadingQueue.addOperation(imageLoader)
                loadingOperations[indexPath] = imageLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
       for indexPath in indexPaths {
           if let imageLoader = loadingOperations[indexPath] {
               imageLoader.cancel()
               loadingOperations.removeValue(forKey: indexPath)
           }
       }
    }
    
}
