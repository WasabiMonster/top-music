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

    var currentExpectaion: XCTestExpectation?
    var viewModel: AlbumsViewModel!
    var data: Data?
    
    override func setUpWithError() throws {
        self.mockURLSession = MockURLSession()
        self.mockApiManager = MockApiManager(urlSession: self.mockURLSession)

        viewModel = AlbumsViewModel()
        viewModel.fetchAlbums(manager: mockApiManager)
        
        let feed: AlbumFeed = self.bundle.decode(AlbumFeed.self, from: "AlbumFeed.json")
        self.modelController = AlbumListModelController(albumFeed: feed)
    }
    
    func testDefaults() {
        XCTAssertEqual(0, viewModel.numberOfAlbums)
        XCTAssertEqual(" ", viewModel.feedTitle)
        XCTAssertNil(viewModel.delegate)
        XCTAssertEqual(" ", viewModel.feedTitle)
    }
    
    func testNumberOfItems() {
        let viewModel = AlbumsViewModel()
        
        //// viewModel.model = AlbumModel(from: <#Decoder#>)
        XCTAssertEqual(100, viewModel.numberOfAlbums)
    }
    
}
