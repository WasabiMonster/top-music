//
//  EmptyServerResponse.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation

struct EmptyServerResponse: MusicServerResponse {

    init() {
    }

    init(from decoder: Decoder) throws {
    }
}
