//
//  MockApiManager.swift
//  Top MusicTests
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
@testable import Top_Music

class MockApiManager: ApiManager {
    let baseUrl = "https://nothing-to-see-here.etechitronica.com/"
    let debuggingEnabled: Bool = true
    let baseUrlParameters: Parameters = ["test": "one"]
    var urlSession: URLSessionProtocol

    init(urlSession: MockURLSession) {
        self.urlSession = urlSession
    }
}
