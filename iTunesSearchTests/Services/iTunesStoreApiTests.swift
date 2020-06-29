//
//  iTunesStoreApiTests.swift
//  iTunesSearchTests
//
//  Created by Justine Tabin on 6/29/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class iTunesStoreApiTests: XCTestCase {
    
    var sut: iTunesStoreApi!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = iTunesStoreApi(baseUrl: MockApi.baseUrl)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testSearch_whenGivenSearchQuery_thenResultsNotNil() {
        // given
        let expect = expectation(description: "Wait for search() to return a value")
        let query = SearchQuery(term: "star", query: "au", media: "movie")
        
        // when
        var gotMoviesResult: StoreResult<[Movie]>?
        var gotError: Error?
        sut.search(query: query) { (result, error) in
            gotMoviesResult = result
            gotError = error
            expect.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 60.0, handler: nil)
        XCTAssertNotNil(gotMoviesResult)
        XCTAssertNil(gotError)
    }
    
    func testLookup_whenGivenQueryBy_thenResultsNotNil() {
        // given
        let expect = expectation(description: "Wait for lookup() to return a value")
        let query = LookupQuery(id: "978943481")
                
        // when
        var gotMoviesResult: StoreResult<[Movie]>?
        var gotError: Error?
        sut.lookup(query: query) { (result, error) in
            gotMoviesResult = result
            gotError = error
            expect.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(gotMoviesResult)
        XCTAssertNil(gotError)
    }

}
