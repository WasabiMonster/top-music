//
//  Genre.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation

struct GenreModel: Codable {
    let genreId: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case genreId
        case name
        case url
    }
    
}
