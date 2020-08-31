//
//  AlbumsViewModelTests.swift
//  Top MusicTests
//
//  Created by Patrick Wilson on 8/28/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import XCTest
@testable import Top_Music

class AlbumsViewModelTests: XCTestCase {
    var mockURLSession: MockURLSession!
    var mockApiManager: ApiManager!

    var currentExpectation: XCTestExpectation?
    var viewModel: AlbumsViewModel!
    var data: Data!
    
    var feed: AlbumFeedResponse!
    var results: [AlbumModel]!
    
    override func setUpWithError() throws {
        self.mockURLSession = MockURLSession()
        self.mockApiManager = MockApiManager(urlSession: self.mockURLSession)

        data = loadTestData(fromFile: "feed", fileExtension: ".json")
        let response = try data.decoded(ofType: AlbumFeedResponse.self)
        results = response?.results
        
        viewModel = AlbumsViewModel()
    }
    
    func testDefaults() {
        XCTAssertEqual(0, viewModel.numberOfAlbums)
        XCTAssertEqual(" ", viewModel.feedTitle)
        XCTAssertNil(viewModel.delegate)
    }
    
    func testNumberOfItems() {
        viewModel.albums = results
        
        XCTAssertEqual(100, viewModel.numberOfAlbums)
    }
    
    func testProperties() {
        viewModel.albums = results
        let response = try? data.decoded(ofType: AlbumFeedResponse.self)
        viewModel.feedResponse = response
        
        XCTAssertEqual("iTunes Store Top Albums", viewModel.feedTitle)
    }
    
    func testRetrieveAlbumAtIndex() {
        viewModel.albums = results
        let album = viewModel.album(at: 1)
        
        XCTAssertEqual("https://music.apple.com/us/album/imploding-the-mirage/1502453888?app=itunes", album.url)
    }
    
}
