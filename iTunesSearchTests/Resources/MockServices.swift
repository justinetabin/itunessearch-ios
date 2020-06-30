//
//  MockServices.swift
//  iTunesSearchTests
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
@testable import iTunesSearch

class MockStoreApi: StoreApi {
    
    static var movies = [
        Movie(trackId: 0,
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
    ]
    
    func search(query: SearchQuery, completion: @escaping (StoreResult<[Movie]>?, Error?) -> Void) {
        completion(StoreResult(resultCount: 1, results: MockStoreApi.movies), nil)
    }
    
    func lookup(query: LookupQuery, completion: @escaping (StoreResult<[Movie]>?, Error?) -> Void) {
        completion(StoreResult(resultCount: 1, results: MockStoreApi.movies), nil)
    }
    
}
