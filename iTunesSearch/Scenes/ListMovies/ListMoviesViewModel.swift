//
//  ListMoviesViewModel.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxRelay

class ListMoviesViewModel: BaseViewModel, ViewModelType {
    
    /*
     View Inputs
     */
    var input = Input(
        viewDidLoad: PublishRelay(),
        pulledToRefresh: PublishRelay()
    )
    
    /*
     View Outputs
     */
    var output = Output(
        showMovies: PublishRelay(),
        showLoadingActivity: PublishRelay()
    )
    
    var worker: CacheMovieDecorator
    private var movies = [Movie]()
    
    init(worker: CacheMovieDecorator) {
        self.worker = worker
        super.init()
        
        self.input.viewDidLoad.bind { [weak self] (_) in
            guard let self = self else { return }
            self.output.showLoadingActivity.accept(true)
            self.worker.searchMovies { (movies) in
                if let movies = movies {
                    self.movies = movies
                    self.output.showMovies.accept(())
                }
                self.output.showLoadingActivity.accept(false)
            }
        }.disposed(by: self.disposeBag)
        
        self.input.pulledToRefresh.bind { [weak self] (_) in
            guard let self = self else { return }
            self.worker.searchMovies { (movies) in
                if let movies = movies {
                    self.movies = movies
                    self.output.showMovies.accept(())
                }
            }
        }.disposed(by: self.disposeBag)
    }
    
    func getMovies() -> [Movie] {
        return self.movies
    }
    
    func getTrackName(at index: Int) -> String {
        self.movies[index].trackName
    }
    
    func getPrimaryGenreName(at index: Int) -> String {
        self.movies[index].primaryGenreName
    }
    
    func getContentAdvisoryRating(at index: Int) -> String {
        self.movies[index].contentAdvisoryRating
    }
    
    func getShortDescription(at index: Int) -> String? {
        self.movies[index].shortDescription
    }
    
    func getAlbumArt(at index: Int, with width: Int) -> String {
        self.movies[index].artworkUrl100.replacingOccurrences(of: "100x100", with: "\(width)x\(width)")
    }
    
    func getTrackPrice(at index: Int) -> String {
        let movie = self.movies[index]
        return movie.trackPrice.currencyValue(currencyCode: movie.currency)
    }
}

extension ListMoviesViewModel {
    
    struct Input {
        var viewDidLoad: PublishRelay<()>
        var pulledToRefresh: PublishRelay<()>
    }
    
    struct Output {
        var showMovies: PublishRelay<()>
        var showLoadingActivity: PublishRelay<(Bool)>
    }
}
