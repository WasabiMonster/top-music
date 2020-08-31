//
//  AlbumFeedRequestTests.swift
//  Top MusicTests
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import XCTest
@testable import Top_Music

class AlbumFeedRequestTests: XCTestCase {
    var mockURLSession: MockURLSession!
    var mockApiManager: ApiManager!
    
    override func setUp() {
        super.setUp()
        self.mockURLSession = MockURLSession()
        self.mockApiManager = MockApiManager(urlSession: self.mockURLSession)
        
    }
    
    func testMakeStoreListRequest() {
        
        self.mockURLSession.nextData = loadTestData(fromFile: "feed", fileExtension: ".json")
        
        let expectation = XCTestExpectation(description: "Receive response")
        
        mockApiManager.execute(Requests.iTunes.topAlbums.init()) { result in
            
                XCTAssertEqual(item?.numOfColors, 1)
                XCTAssertEqual(item?.loggedStoreCategoryID, "10279")
                XCTAssertEqual(item?.loggedDoteCategoryID, "3")
                XCTAssertEqual(item?.isNew, true)
                XCTAssertEqual(item?.isSeen, false)
                XCTAssertEqual(item?.isFavorite, false)
                XCTAssertEqual(item?.favoriteListsIDs, ["1", "2"])
                XCTAssertEqual(item?.isPurchased, false)
                XCTAssertEqual(item?.analyticsDict["item_id"] as? Int, 8207574) */
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
