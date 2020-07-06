//
//  MovieCoreDataStore.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/28/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import CoreData
import RxRelay

class MovieCoreDataStore: MovieDataStore {
    
    var coreDataStorage: CoreDataStorage
    
    var didUpsertBrowsedMovie = PublishRelay<BrowsedMovie?>()
    
    init(coreDataStorage: CoreDataStorage) {
        self.coreDataStorage = coreDataStorage
    }
    
    func getMovie(trackId: Int, completion: @escaping (Movie?) -> Void) {
        self.coreDataStorage.getBackgroundContext { (context) in
            do {
                let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                request.predicate = NSPredicate(format: "trackId == %i", Int32(trackId))
                let result = try request.execute()
                if let movieEntity = result.first {
                    completion(movieEntity.toMovie())
                } else {
                    completion(nil)
                }
            } catch _ {
                completion(nil)
            }
        }
    }
    
    func listMovie(page: Page, completion: @escaping ([Movie]?) -> Void) {
        self.coreDataStorage.getBackgroundContext { (context) in
            do {
                let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//                request.fetchLimit = page.limit
//                request.fetchOffset = page.skip
                let result = try request.execute()
                completion(result.map { $0.toMovie() })
            } catch _ {
                completion(nil)
            }
        }
    }
    
    func upsertMovie(movieToUpsert: Movie, completion: @escaping (Bool) -> Void) {
        self.coreDataStorage.getBackgroundContext { (context) in
            do {
                let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                request.predicate = NSPredicate(format: "trackId == %i", Int32(movieToUpsert.trackId))
                let result = try context.fetch(request)
                if let movieEntity = result.first {
                    movieEntity.from(movie: movieToUpsert)
                } else {
                    let _ = MovieEntity(movie: movieToUpsert, insertInto: context)
                }
                try context.save()
                completion(true)
            } catch _ {
                completion(false)
            }
        }
    }
    
    func deleteMovie(movie: Movie, completion: @escaping (Bool) -> Void) {
        self.coreDataStorage.getBackgroundContext { (context) in
            do {
                let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                request.predicate = NSPredicate(format: "trackId == %i", Int32(movie.trackId))
                let result = try request.execute()
                if let movieEntity = result.first {
                    context.delete(movieEntity)
                    try context.save()
                    completion(true)
                } else {
                    completion(false)
                }
            } catch _ {
                completion(false)
            }
        }
    }
    
    func listBrowsedMovies(completion: @escaping ([BrowsedMovie]?) -> Void) {
        self.coreDataStorage.getBackgroundContext { (context) in
            do {
                let request: NSFetchRequest<BrowsedMovieEntity> = BrowsedMovieEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "browsedAt", ascending: false)]
                let results = try request.execute()
                var browsedMovies = [BrowsedMovie]()
                results.forEach { (result) in
                    if let browsedMovie = result.toBrowsedMovie() {
                        browsedMovies.append(browsedMovie)
                    }
                }
                completion(browsedMovies)
            } catch _ {
                completion(nil)
            }
        }
    }
    
    func upsertBrowsedMovie(movie: Movie, completion: @escaping (BrowsedMovie?) -> Void) {
        self.coreDataStorage.getBackgroundContext { (context) in
            do {
                let request: NSFetchRequest<BrowsedMovieEntity> = BrowsedMovieEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %i", movie.trackId)
                let result = try request.execute()
                var browsedMovie: BrowsedMovie?
                if let browsedMovieEntity = result.first {
                    browsedMovieEntity.browsedAt = Date()
                    browsedMovie = browsedMovieEntity.toBrowsedMovie()
                } else {
                    let browsedMovieEntity = BrowsedMovieEntity(browsedMovie: BrowsedMovie(id: movie.trackId,
                                                                                           movie: movie,
                                                                                           browsedAt: Date()),
                                                                insertInto: context)
                    browsedMovie = browsedMovieEntity.toBrowsedMovie()
                }
                try context.save()
                self.didUpsertBrowsedMovie.accept(browsedMovie)
                completion(browsedMovie)
            } catch _ {
                completion(nil)
            }
        }
    }
}
