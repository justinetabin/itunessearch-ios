//
//  Movie+CoreData.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/29/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import CoreData

extension MovieEntity {
    
    convenience init(movie: Movie, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.from(movie: movie)
    }
    
    func from(movie: Movie) {
        self.artistName = movie.artistName
        self.artworkUrl100 = movie.artworkUrl100
        self.artworkUrl30 = movie.artworkUrl30
        self.artworkUrl60 = movie.artworkUrl60
        self.collectionName = movie.collectionName
        self.collectionPrice = movie.collectionPrice
        self.contentAdvisoryRating = movie.contentAdvisoryRating
        self.country = movie.country
        self.currency = movie.currency
        self.longDesc = movie.longDescription
        self.previewUrl = movie.previewUrl
        self.primaryGenreName = movie.primaryGenreName
        self.releaseDate = movie.releaseDate
        self.shortDesc = movie.shortDescription
        self.trackId = Int32(movie.trackId)
        self.trackName = movie.trackName
        self.trackTimeMillis = Int32(movie.trackTimeMillis)
        self.trackPrice = movie.trackPrice
    }
    
    func toMovie() -> Movie {
        return Movie(trackId: Int(self.trackId),
                     collectionName: self.collectionName ?? "",
                     artistName: self.artistName ?? "",
                     trackName: self.trackName ?? "",
                     previewUrl: self.previewUrl ?? "",
                     artworkUrl30: self.artworkUrl30 ?? "",
                     artworkUrl60: self.artworkUrl60 ?? "",
                     artworkUrl100: self.artworkUrl100 ?? "",
                     collectionPrice: self.collectionPrice,
                     trackPrice: self.trackPrice,
                     releaseDate: self.releaseDate ?? "",
                     primaryGenreName: self.primaryGenreName ?? "",
                     contentAdvisoryRating: self.contentAdvisoryRating ?? "",
                     shortDescription: self.shortDesc ?? "",
                     longDescription: self.longDesc ?? "",
                     country: self.country ?? "",
                     currency: self.currency ?? "",
                     trackTimeMillis: Int(self.trackTimeMillis))
    }
}
