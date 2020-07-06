//
//  CacheMovieDecorator.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxRelay

class CacheMovieDecorator: CacheMovieProtocols {
    var movieWorker: MovieWorker
    var movieDataStore: MovieDataStore
    
    var didUpsertBrowsedMovie: PublishRelay<BrowsedMovie?> {
        return movieDataStore.didUpsertBrowsedMovie
    }
    
    init(movieWorker: MovieWorker, movieDataStore: MovieDataStore) {
        self.movieWorker = movieWorker
        self.movieDataStore = movieDataStore
    }
    
    func searchMovies(completion: @escaping ([Movie]?) -> Void) {
        self.movieWorker.searchMovies { (movies) in
            if let movies = movies {
                /*
                 network success -> datastore
                                 -> view
                 */
                movies.forEach { (movie) in
                    self.movieDataStore.upsertMovie(movieToUpsert: movie) { (result) in }
                }
                completion(movies)
            } else {
                /*
                 network failure -> datastore -> view
                 */
                self.movieDataStore.listMovie(page: Page(skip: 0)) { (movies) in
                    if let movies = movies {
                        completion(movies)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func getMovie(trackId: Int, completion: @escaping (Movie?) -> Void) {
        self.movieWorker.getMovie(trackId: trackId) { (movie) in
            if let movie = movie {
                /*
                 network success -> datastore
                                 -> view
                 */
                self.movieDataStore.upsertMovie(movieToUpsert: movie) { (_) in }
                
                // temporarily upsert this movie directly to data store
                // when got a movie
                self.movieDataStore.upsertBrowsedMovie(movie: movie) { (_) in }
                
                completion(movie)
            } else {
                /*
                 network failure -> datastore -> view
                 */
                self.movieDataStore.getMovie(trackId: trackId) { (movie) in
                    if let movie = movie {
                        self.movieDataStore.upsertMovie(movieToUpsert: movie) { (_) in }
                        
                        // temporarily upsert this movie directly to data store
                        // when got a movie
                        self.movieDataStore.upsertBrowsedMovie(movie: movie) { (_) in }
                        completion(movie)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func listBrowsedMovies(completion: @escaping ([BrowsedMovie]?) -> Void) {
        self.movieWorker.listBrowsedMovies { (browsedMovies) in
            // for now it's gonna network failure, regardless fetch from data store instead
            self.movieDataStore.listBrowsedMovies(completion: completion)
        }
    }
    
    func upsertBrowsedMovie(movie: Movie, completion: @escaping (BrowsedMovie?) -> Void) {
        self.movieWorker.upsertBrowsedMovie(movie: movie) { (browsedMovie) in
            // for now it's gonna network failure, regardless upsert from data store instead
            self.movieDataStore.upsertBrowsedMovie(movie: movie, completion: completion)
        }
    }
}

protocol CacheMovieProtocols {
    func searchMovies(completion: @escaping ([Movie]?) -> Void)
    func getMovie(trackId: Int, completion: @escaping (Movie?) -> Void)
    func listBrowsedMovies(completion: @escaping ([BrowsedMovie]?) -> Void)
    func upsertBrowsedMovie(movie: Movie, completion: @escaping (BrowsedMovie?) -> Void)
}
