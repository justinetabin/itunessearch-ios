//
//  MovieWorkerTests.swift
//  iTunesSearchTests
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class MovieWorkerTests: XCTestCase {
    
    var testMovies = MockStoreApi.movies
    var sut: MovieWorker!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storeApi = MockStoreApi()
        sut = MovieWorker(storeApi: storeApi)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testSearch_whenSearchMovies_thenShouldReturnMovies() {
        // given
        let expect = expectation(description: "Wait for searchMovie")
        let expectedMovies = self.testMovies
        
        // when
        var gotMovies: [Movie]?
        self.sut.searchMovies { (movies) in
            gotMovies = movies
            expect.fulfill()
        }
        
        // then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(gotMovies)
        XCTAssertEqual(gotMovies, expectedMovies)
    }
    
    func testLookup_whenGotMovies_thenShouldMatchExpectedMovies() {
        // given
        let expect = self.expectation(description: "Wait until getMovies() return")
        let expectedMovie = self.testMovies[0]
        
        // when
        var gotMovies: Movie?
        self.sut.getMovie(trackId: 0) { (movies) in
            gotMovies = movies
            expect.fulfill()
        }
        
        // then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(gotMovies)
        XCTAssertEqual(gotMovies, expectedMovie)
    }

}
