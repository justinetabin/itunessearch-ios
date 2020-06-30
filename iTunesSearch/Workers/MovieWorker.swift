//
//  MovieWorker.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/28/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class MovieWorker: CacheMovieProtocols {
    var storeApi: StoreApi
    
    init(storeApi: StoreApi) {
        self.storeApi = storeApi
    }
    
    func searchMovies(completion: @escaping ([Movie]?) -> Void) {
        let query = SearchQuery(term: "star", country: "au", media: "movie")
        self.storeApi.search(query: query) { (result, error) in
            completion(result?.results)
        }
    }
    
    func getMovie(trackId: Int, completion: @escaping (Movie?) -> Void) {
        let query = LookupQuery(id: trackId, country: "au")
        self.storeApi.lookup(query: query) { (result, error) in
            completion(result?.results.first)
        }
    }
}

protocol StoreApi {
    func search(query: SearchQuery, completion: @escaping (StoreResult<[Movie]>?, Error?) -> Void)
    func lookup(query: LookupQuery, completion: @escaping (StoreResult<[Movie]>?, Error?) -> Void)
}

protocol MovieDataStore {
    func upsertMovie(movieToUpsert: Movie, completion: @escaping (Bool) -> Void)
    func getMovie(trackId: Int, completion: @escaping (Movie?) -> Void)
    func listMovie(page: Page, completion: @escaping ([Movie]?) -> Void)
    func deleteMovie(movie: Movie, completion: @escaping (Bool) -> Void)
}
