//
//  ListMoviesModel.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 7/5/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol ListMoviesModel {
    var movies: [Movie] { get }
}

class ListMoviesSearched: ListMoviesModel {
    var movies: [Movie]
    
    init(movies: [Movie]) {
        self.movies = movies
    }
}

class ListMoviesBrowsed: ListMoviesModel {
    var movies: [Movie]
    
    init(movies: [Movie]) {
        self.movies = movies
    }
}
