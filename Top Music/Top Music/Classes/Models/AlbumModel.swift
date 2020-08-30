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
    let releaseDate: Date?
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        artistName = try container.decode(String.self, forKey: .artistName)
        id = try container.decode(String.self, forKey: .id)
        artworkUrl = try container.decode(String.self, forKey: .artworkUrl)
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        let formatter = DateFormatter.yyyyMMdd
        if let date = formatter.date(from: dateString) {
            releaseDate = date
        } else {
            releaseDate = nil
        }
        copyright = try container.decode(String.self, forKey: .copyright)
        genres = try container.decode([GenreModel].self, forKey: .genres)
    }
    
}
