//
//  Album.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

struct Album: Codable {
    let artistName: String
    let id: String
    let artworkUrl: String
    let genres:[Genre]
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case id
        case genres
        case artworkUrl = "artworkUrl100"
    }
    
}

private extension Album {
    
    
}
