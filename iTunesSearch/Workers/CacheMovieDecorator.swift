//
//  CacheMovieDecorator.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class CacheMovieDecorator: CacheMovieProtocols {
    var movieWorker: MovieWorker
    var movieDataStore: MovieDataStore
    
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
                    self.movieDataStore.upsertMovie(movieToUpsert: movie) { (_) in }
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
                 network -> datastore
                         -> view
                 */
                self.movieDataStore.upsertMovie(movieToUpsert: movie) { (_) in }
                completion(movie)
            } else {
                /*
                 network -> datastore -> view
                 */
                self.movieDataStore.getMovie(trackId: trackId) { (movie) in
                    if let movie = movie {
                        self.movieDataStore.upsertMovie(movieToUpsert: movie) { (_) in }
                        completion(movie)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
}

protocol CacheMovieProtocols {
    func searchMovies(completion: @escaping ([Movie]?) -> Void)
    func getMovie(trackId: Int, completion: @escaping (Movie?) -> Void)
}
