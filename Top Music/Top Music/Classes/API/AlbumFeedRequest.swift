//
//  AlbumFeedRequest.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

struct AlbumFeedRequest: MusicServerRequest {
    typealias ResponseType = AlbumFeedResponse

    let path = "api/v1/us/itunes-music/top-albums/all/100/explicit.json"
}

struct AlbumFeedResponse: MusicServerResponse {
    let title: String
    let id: String
    let results: [AlbumModel]?
    
    private enum CodingKeys: String, CodingKey {
        case feed
        case title
        case id
        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let feed = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .feed)
        title = try feed.decode(String.self, forKey: .title)
        id = try feed.decode(String.self, forKey: .id)
        results = try feed.decode([AlbumModel].self, forKey: .results)
    }
}
