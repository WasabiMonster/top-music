//
//  Requests.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

// Multi-level enum to serve as a directory of requests
// Included as a good measure for a project that scales
// Additional requests may be added for CRUD operations
// or Further API requests (i.e. Apple Music instead of
// iTunes)
enum Requests {
    
    enum iTunes {
        static let topAlbums = AlbumFeedRequest.self
    }
    
}
