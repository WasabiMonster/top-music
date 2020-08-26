//
//  ApiManager.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

// Required params for any API Manager
protocol ApiManager {
    var baseUrl: String { get }
    var urlSession: URLSessionProtocol { get }
    var debuggingEnabled: Bool { get }
    var baseUrlParameters: Parameters { get }
    var baseHeaders: HTTPHeaders { get }
}

// defaults
extension ApiManager {
    var urlSession: URLSessionProtocol {
        return URLSession.shared
    }

    var debuggingEnabled: Bool {
        return Environment.current.networkLoggingEnabled
    }

    var baseUrlParameters: Parameters {
        return [:]
    }

    var baseHeaders: HTTPHeaders {
        return [:]
    }
}

// execution
extension ApiManager {
    // main function to execute a network request
    @discardableResult func execute<T: MusicServerRequest>(
        _ request: T,
        completion: @escaping T.RequestCompletion) -> URLSessionTask? {
        return request.execute(apiManager: self, completion: completion)
    }

    // calls completion block when all requests are complete
    func waitForAllPendingRequests(completion: @escaping () -> Void) {
        urlSession.getAllTasks { allTasks in
            if allTasks.count == 0 {
                completion()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.waitForAllPendingRequests(completion: completion)
                }
            }
        }
    }
}
