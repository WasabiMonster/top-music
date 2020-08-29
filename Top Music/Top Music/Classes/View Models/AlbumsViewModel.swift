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
    var albums: [AlbumModel] = []
    weak var tableView: UITableView?
    
    func fetchAlbums() {
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

extension AlbumsViewModel: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
