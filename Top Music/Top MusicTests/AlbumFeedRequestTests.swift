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
    
    func testMakeFeedRequest() {
        
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
                XCTAssertEqual(feedResponse.title, "Top Albums")
                XCTAssertEqual(feedResponse.author.name, "iTunes Store")
                XCTAssertEqual(feedResponse.author.uri, "http://wwww.apple.com/us/itunes/")
                XCTAssertEqual(feedResponse.id, "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/all/100/explicit.json")
                XCTAssertEqual(feedResponse.results?.count, 100)

                // check the first result album
                guard let album = feedResponse.results?.first else {
                    XCTFail("First Album should have a value")
                    return
                }

                XCTAssertEqual(album.name, "King's Disease")
                XCTAssertEqual(album.artistName, "Nas")
                XCTAssertEqual(album.id, "1528092359")
                XCTAssertEqual(album.artworkUrl, "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/14/4a/8f/144a8f2c-c723-2413-291b-ba2fe2819456/20UMGIM71728.rgb.jpg/200x200bb.png")

                let formatter = DateFormatter.yyyyMMdd
                XCTAssertEqual(album.releaseDate, formatter.date(from: "2020-08-21"))

                XCTAssertEqual(album.copyright, "℗ 2020 Mass Appeal")
                XCTAssertEqual(album.genres.count, 2)
                XCTAssertEqual(album.url, "https://music.apple.com/us/album/kings-disease/1528092359?app=itunes")
                XCTAssertEqual(album.imageLoadStatus, .start)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
