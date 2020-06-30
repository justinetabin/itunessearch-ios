//
//  MovieCoreDataStoreTests.swift
//  iTunesSearchTests
//
//  Created by Justine Tabin on 6/29/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class MovieCoreDataStoreTests: XCTestCase {
    
    var testMovie: Movie!
    var sut: MovieCoreDataStore!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let coreDataStorage = CoreDataStorage()
        self.testMovie = Movie(trackId: 0,
                               collectionName: "myCollectionName",
                               artistName: "myArtistName",
                               trackName: "myTrackName",
                               previewUrl: "myPreviewUrl",
                               artworkUrl30: "myArtworkUrl30",
                               artworkUrl60: "myArtwork60",
                               artworkUrl100: "myArtwork100",
                               collectionPrice: 19.99,
                               trackPrice: 9.99,
                               releaseDate: "01-01-1995",
                               primaryGenreName: "myPrimaryGenre",
                               contentAdvisoryRating: "myContentAdvisoryRating",
                               shortDescription: "myShortDescription",
                               longDescription: "myLongDescription",
                               country: "myCountry",
                               currency: "myCurrency",
                               trackTimeMillis: 60000)
        self.sut = MovieCoreDataStore(coreDataStorage: coreDataStorage)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.sut = nil
    }

    func testGet_whenGivenTrackId_thenShouldMatchMovie() {
        // given
        let expect = self.expectation(description: "Wait for getMovie()")
        expect.expectedFulfillmentCount = 2
        let expectedMovie = self.testMovie
        
        // when
        var gotMovie: Movie?
        self.sut.upsertMovie(movieToUpsert: self.testMovie) { (success) in
            self.sut.getMovie(trackId: expectedMovie!.trackId) { (movie) in
                gotMovie = movie
                expect.fulfill()
                self.sut.deleteMovie(movie: self.testMovie) { (_) in
                    expect.fulfill()
                }
            }
        }
        
        // then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        XCTAssertEqual(gotMovie, expectedMovie)
    }
    
    func testList_whenGivenFirstPage_thenShouldMatchMovies() {
        // given
        let expect = expectation(description: "Wait for listMovies()")
        expect.expectedFulfillmentCount = 2
        let givenPage = Page(skip: 0)
        let expectedMovie: Movie = self.testMovie
        
        // when
        var gotMovies: [Movie]?
        self.sut.upsertMovie(movieToUpsert: self.testMovie) { (success) in
            self.sut.listMovie(page: givenPage) { (movies) in
                gotMovies = movies
                expect.fulfill()
                self.sut.deleteMovie(movie: self.testMovie) { (_) in
                    expect.fulfill()
                }
            }
        }
        
        // then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        XCTAssertNotNil(gotMovies)
        XCTAssert(gotMovies!.contains(expectedMovie))
    }

}
