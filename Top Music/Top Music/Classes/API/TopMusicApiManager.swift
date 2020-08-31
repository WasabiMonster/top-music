//
//  TopMusicApiManager.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation

// Convenience top-level global for easier access to the shared api manager
let apiManager = TopMusicApiManager.shared

// The app uses the shared singleton, tests can create mock versions of this to simulate network requests
class TopMusicApiManager: ApiManager {
    static let shared = TopMusicApiManager()

    let baseUrl = Environment.current.serverBaseUrlString

    var baseUrlParameters: Parameters {
        var params = Parameters()
        // On a larger scale app additional common params can be sent here on
        // every request. This could potentially include an authToken, uuid,
        // or app version.
        // params["version"] = "0.0.0"
        return params
    }

}
