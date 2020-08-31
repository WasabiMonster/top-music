//
//  MockURLSession.swift
//  Top MusicTests
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
@testable import Top_Music

class MockURLSession: URLSessionProtocol {

    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data? = "{}".data(using: .utf8)
    var nextError: Error?
    var nextStatus: Int = 200

    private (set) var lastURLRequest: URLRequest?

    func reset() {
        nextData = "{}".data(using: .utf8)
        nextError = nil
        nextStatus = 200
    }

    func httpURLResponse(request: URLRequest) -> URLResponse {
        guard let url = request.url,
            let response = HTTPURLResponse(url: url, statusCode: nextStatus, httpVersion: "HTTP/1.1", headerFields: nil) else {
            return HTTPURLResponse()
        }

        return response
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURLRequest = request

        completionHandler(nextData, httpURLResponse(request: request), nextError)
        return nextDataTask
    }

    func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void) {
        completionHandler([])
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
}
