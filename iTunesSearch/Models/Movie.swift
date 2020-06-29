//
//  Movie.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/28/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var trackId: Int
    var collectionName: String?
    var artistName: String
    var trackName: String
    var previewUrl: String
    var artworkUrl30: String
    var artworkUrl60: String
    var artworkUrl100: String
    var collectionPrice: Double
    var trackPrice: Double
    var releaseDate: String
    var primaryGenreName: String
    var contentAdvisoryRating: String
    var shortDescription: String?
    var longDescription: String
    var country: String
    var currency: String
    var trackTimeMillis: Int
}
