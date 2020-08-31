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
            
            guard let url = self.mockURLSession.lastURLRequest?.url
                else { XCTFail("missing url"); return }
            
            XCTAssertTrue(url.absoluteString.contains("/us/itunes-music/top-albums/all/100"), "url called has proper path")
            
            switch result {
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            case .success(let feedResponse):
                XCTAssertNotNil(feedResponse)
                
                // check the first level properties
                print("*083020* \(type(of: self)), \(#function) |> \(feedResponse.title)")
                print("*083020* \(type(of: self)), \(#function) |> \(feedResponse.author)")
                print("*083020* \(type(of: self)), \(#function) |> \(feedResponse.id)")
                print("*083020* \(type(of: self)), \(#function) |> \(feedResponse.results?.count)")
                
                /*
                let title: String
                let author: AlbumAuthorModel
                let id: String
                let results: [AlbumModel]?
                */
                
                // let list = storeListResponse.lists.first
                
                
                /* XCTAssertEqual(list?.headerTitle, "New Arrivals")
                XCTAssertEqual(list?.listType, "new")
                XCTAssertEqual(list?.deepLinkDict["notif_type"] as? String, "search")
                XCTAssertEqual(list?.items.count, 12)
                
                // check the first item
                let item = list?.items.first
                XCTAssertEqual(item?.ID, "8207574")
                XCTAssertEqual(item?.name, "Strawberry Print Phone Ring")
                XCTAssertEqual(item?.url, URL("https://www.forever21.com/us/shop/Catalog/Product/F21/ACC/1000352881"))
                XCTAssertEqual(item?.desktopUrl, URL("https://www.doteshopping.com/shop/items/8207574-strawberry-print-phone-ring"))
                XCTAssertEqual(item?.msrpInDollars, 5.90)
                XCTAssertEqual(item?.priceInDollars, 5.90)
                XCTAssertEqual(item?.coinValue, 1000)
                XCTAssertEqual(item?.score, 0)
                XCTAssertEqual(item?.storeID, "10")
                XCTAssertEqual(item?.allSizes, [])
                XCTAssertEqual(item?.isSoldOut, false)
                XCTAssertEqual(item?.badges, [])
                XCTAssertEqual(item?.imageInfo?.imageUrl, URL("https://d3e1z3hxo3xobu.cloudfront.net/api/uploads/image/file/93405965/thumb_00352881-01.jpg"))
                XCTAssertEqual(item?.imageInfo?.imageWidth, 243)
                XCTAssertEqual(item?.imageInfo?.imageHeight, 364)
                XCTAssertEqual(item?.imageInfo?.ID, "93405965")
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
