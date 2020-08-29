//
//  AlbumsViewModelTests.swift
//  Top MusicTests
//
//  Created by Patrick Wilson on 8/28/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import XCTest
@testable import Top_Music

class AlbumsViewModelTests: XCTestCase {
    
    var currentExpectaion: XCTestExpectation?
    
    func testDefaults() {
        let viewModel = AlbumsViewModel()
        XCTAssertEqual(0, viewModel.numberOfAlbums)
        XCTAssertEqual("iTunes Store Top Albums", viewModel.feedTitle)
        XCTAssertNil(viewModel.delegate)
        XCTAssertNil(viewModel.albums)
    }
    
    func testNumberOfItems() {
        let viewModel = AlbumsViewModel()
        
        viewModel.model = AlbumModel()
        XCTAssertEqual(100, viewModel.numberOfAlbums)
    }
    
}
