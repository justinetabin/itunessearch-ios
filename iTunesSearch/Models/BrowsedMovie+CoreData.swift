//
//  BrowsedMovie+CoreData.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 7/5/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import CoreData

extension BrowsedMovieEntity {
    
    convenience init(browsedMovie: BrowsedMovie, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(browsedMovie.id)
        self.ofMovieEntity = MovieEntity(movie: browsedMovie.movie, insertInto: context)
        self.browsedAt = browsedMovie.browsedAt
    }
    
    func toBrowsedMovie() -> BrowsedMovie? {
        if let movie = self.ofMovieEntity, let browsedAt = self.browsedAt {
            return BrowsedMovie(id: Int(self.id), movie: movie.toMovie(), browsedAt: browsedAt)
        }
        return nil
    }
    
}
