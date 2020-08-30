//
//  Codable+extensions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation

extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension Data {
    func decoded<T: Decodable>(ofType type: T.Type) throws -> T? {
        var decoded: T?
        do {
            decoded = try JSONDecoder().decode(type, from: self)
        } catch let error {
            print("Error decoding data: \(error) MODEL: \(type)")
        }
        return decoded
    }
}
