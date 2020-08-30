//
//  AlbumDetailViewModel.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation

protocol AlbumDetailViewModelDelegate: class {
    func didGetError(_ error: Error)
    func detailDidChange(viewModel: AlbumDetailViewModel)
}

class AlbumDetailViewModel: NSObject, BaseViewModel {
    weak var delegate: AlbumDetailViewModelDelegate?
    
    var detail: AlbumModel? {
        didSet {
            delegate?.detailDidChange(viewModel: self)
        }
    }
    
    var id: String {
        return detail?.id ?? ""
    }
    
    var albumText: String {
        return detail?.name ?? ""
    }
    
    var artistText: String {
        return detail?.artistName ?? ""
    }
    
    var artworkUrl: String {
        return detail?.artworkUrl ?? ""
    }
    
    var genreText: String {
        return detail?.genres.map{$0.name}.joined(separator: ", ") ?? ""
    }

    var releaseDateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        if let date = detail?.releaseDate {
            return "Released: \(dateFormatter.string(from: date))"
        }
        return ""
    }
    
    var copyrightText: String {
        return detail?.copyright ?? ""
    }
    
    var iTunesUrl: String {
        return detail?.url ?? "http://www.apple.com"
    }
    
}
