//
//  XCTestCaseExtensions.swift
//  Top MusicTests
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import XCTest

extension XCTestCase {

    func loadTestData(fromFile fileName: String, fileExtension: String) -> Data? {
        guard let path = Bundle(for: self.classForCoder).path(forResource: fileName, ofType: fileExtension) else {
            return nil
        }

        guard let str = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            return nil
        }

        return str.data(using: String.Encoding.utf8)
    }

    func loadTestDataAsJson(fromFile fileName: String, fileExtension: String) -> AnyObject? {

        guard let data = loadTestData(fromFile: fileName, fileExtension: fileExtension) else {
            return nil
        }

        return try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
    }
}
