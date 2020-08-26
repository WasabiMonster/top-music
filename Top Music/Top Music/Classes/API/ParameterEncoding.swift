//
//  ParameterEncoding.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public struct ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) {

        guard let url = urlRequest.url else { return }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {

            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                urlComponents.queryItems?.append(contentsOf: queryItems(forKey: key, value: value))
            }
            urlRequest.url = urlComponents.url
        }
    }

    private static func queryItems(forKey key: String, value: Any) -> [URLQueryItem] {
        var urlQueryItems: [URLQueryItem] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, nestedValue) in dictionary {
                urlQueryItems.append(contentsOf: queryItems(forKey: "\(key)[\(nestedKey)]", value: nestedValue))
            }
        } else if let array = value as? [Any] {
            for value in array {
                urlQueryItems.append(contentsOf: queryItems(forKey: "\(key)[]", value: value))
            }
        } else {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlQueryItems.append(queryItem)
        }

        return urlQueryItems
    }

}
