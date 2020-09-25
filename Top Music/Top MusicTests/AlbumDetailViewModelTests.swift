//
//  AlbumDetailViewModelTests.swift
//  Top MusicTests
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import XCTest
@testable import Top_Music

class AlbumDetailViewModelTests: XCTestCase {
    var mockURLSession: MockURLSession!
    var mockApiManager: ApiManager!

    var viewModel: AlbumDetailViewModel!
    var data: Data!
        
    override func setUpWithError() throws {
        self.mockURLSession = MockURLSession()
        self.mockApiManager = MockApiManager(urlSession: self.mockURLSession)

        data = loadTestData(fromFile: "feed", fileExtension: ".json")
        let response = try? data.decoded(ofType: AlbumFeedResponse.self)
        viewModel = AlbumDetailViewModel(detail: (response?.results?[1])!)
    }
    
    func testProperties() {
        XCTAssertEqual("Imploding the Mirage", viewModel.albumText)
        XCTAssertEqual("The Killers", viewModel.artistText)
        XCTAssertEqual("Imploding the Mirage", viewModel.albumText)
        XCTAssertEqual("1502453888", viewModel.id)
        XCTAssertEqual("https://is4-ssl.mzstatic.com/image/thumb/Music113/v4/df/ad/d9/dfadd9a6-a54c-cffa-7312-0705b0c22a4b/20UMGIM16911.rgb.jpg/200x200bb.png", viewModel.artworkUrl)
        XCTAssertEqual("Released: August 20, 2020", viewModel.releaseDateText)
        XCTAssertEqual("℗ 2020 Island Records, a division of UMG Recordings, Inc.", viewModel.copyrightText)
        XCTAssertEqual("Alternative, Music", viewModel.genreText)
        XCTAssertEqual("https://music.apple.com/us/album/imploding-the-mirage/1502453888?app=itunes", viewModel.iTunesUrl)
    }
    
}
