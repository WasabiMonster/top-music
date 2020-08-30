//
//  Album.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

struct AlbumModel: Decodable {
    let name: String
    let artistName: String
    let id: String
    let artworkUrl: String
    let releaseDate: String
    let copyright: String
    let genres:[GenreModel]
    
    enum CodingKeys: String, CodingKey {
        case name
        case artistName
        case id
        case artworkUrl = "artworkUrl100"
        case releaseDate
        case copyright
        case genres
    }
    
}
