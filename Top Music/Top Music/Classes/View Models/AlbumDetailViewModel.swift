//
//  AlbumDetailViewModel.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
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
        return detail?.releaseDate ?? ""
    }
    
    var copyrightText: String {
        return detail?.copyright ?? ""
    }
    
    
    
}
