//
//  ServerErrorMessageResponse.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

// A struct to encapsulate server returned error messages
// If we can decode into this response, and if it's an error, treat the call as failed
struct ServerErrorMessageResponse {
    let message: String
    var isError: Bool {
        return !message.isEmpty
    }
}

