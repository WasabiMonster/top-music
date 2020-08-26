//
//  URLSessionProtocol.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

// Protocol for both MOCK and Real url session object
// Allows us to inject a mock URLSession in tests
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void)
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
