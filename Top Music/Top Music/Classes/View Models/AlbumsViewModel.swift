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
    weak var delegate: AlbumsViewModelDelegate?
    private var feedResponse: AlbumFeedResponse?
    private var albums: [AlbumModel] = []  // AlbumViewModel
    weak var tableView: UITableView?
    
    var feedTitle: String {
        return "\(feedResponse?.author.name ?? "") \(feedResponse?.title ?? "")"
    }
    
    var numberOfAlbums: Int {
        return albums.count
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
                          artwork: nil
                          // artwork: album.artworkUrl
                          )
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension AlbumsViewModel: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("*082820* \(type(of: self)), \(#function) |> \(indexPath)")
    }
    
}
