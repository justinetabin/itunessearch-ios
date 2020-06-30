//
//  DependencyWorker.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol WorkerFactory {
    func makeMovieWorker() -> MovieWorker
    func makeCacheMovieDecorator() -> CacheMovieDecorator
}

protocol ViewControllerFactory {
    
}

/*
 - The dependency container for the entire app
 
 - The main purpose of this class is to glue all components
 
 - It contains several factory such as ViewController, Worker
 
 - It contains services such as API web services, CoreData
 */
class DependencyWorker {
    var storeApi: StoreApi
    var movieStore: MovieDataStore
    
    init() {
        self.storeApi = iTunesStoreApi(baseUrl: Api.baseUrl)
        self.movieStore = MovieCoreDataStore(coreDataStorage: CoreDataStorage())
    }
}

extension DependencyWorker: WorkerFactory {
    
    func makeMovieWorker() -> MovieWorker {
        return MovieWorker(storeApi: self.storeApi)
    }
    
    func makeCacheMovieDecorator() -> CacheMovieDecorator {
        return CacheMovieDecorator(movieWorker: self.makeMovieWorker(), movieDataStore: self.movieStore)
    }
}

extension DependencyWorker: ViewControllerFactory {
    
}
