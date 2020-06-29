//
//  MovieStoreWorker.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/28/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class MovieStoreWorker {
    
}

protocol MovieDataStore {
    func upsertMovie(movieToUpsert: Movie, completion: @escaping (Bool) -> Void)
    func getMovie(trackId: Int, completion: @escaping (Movie?) -> Void)
    func listMovie(page: Page, completion: @escaping ([Movie]?) -> Void)
}
