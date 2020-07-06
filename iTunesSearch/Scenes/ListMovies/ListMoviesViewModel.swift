//
//  ListMoviesViewModel.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

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
        showMovies: BehaviorRelay(value: []),
        showLoadingActivity: PublishRelay()
    )
    
    var worker: CacheMovieDecorator
    
    private var models = [ListMoviesModel]()
    
    init(worker: CacheMovieDecorator) {
        self.worker = worker
        super.init()
        
        self.worker.didUpsertBrowsedMovie.bind { [weak self] (browsedMovie) in
            guard let self = self else { return }
            if let browsedMovie = browsedMovie {
                if let browsedModel = self.models.first as? ListMoviesBrowsed {
                    browsedModel.movies = browsedModel.movies.filter { (movie) -> Bool in
                        return movie.trackId != browsedMovie.movie.trackId
                    }
                    browsedModel.movies.insert(browsedMovie.movie, at: 0)
                } else {
                    self.models.insert(ListMoviesBrowsed(movies: [browsedMovie.movie]), at: 0)
                }
            }
            self.output.showMovies.accept(self.models)
        }.disposed(by: self.disposeBag)
        
        self.input.viewDidLoad.bind { [weak self] (_) in
            self?.fetchData()
        }.disposed(by: self.disposeBag)
        
        self.input.pulledToRefresh.bind { [weak self] (_) in
            self?.fetchData()
        }.disposed(by: self.disposeBag)
    }
    
    private func fetchData() {
        self.output.showLoadingActivity.accept(self.models.isEmpty)
        
        var models = [ListMoviesModel]()
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.worker.listBrowsedMovies { (browsedMovies) in
                if let browsedMovies = browsedMovies, browsedMovies.count > 0 {
                    let movies = browsedMovies.map { $0.movie }
                    models.insert(ListMoviesBrowsed(movies: movies), at: 0)
                }
                semaphore.signal()
            }
            semaphore.wait()
            
            self.worker.searchMovies { (movies) in
                if let movies = movies {
                    models.append(ListMoviesSearched(movies: movies))
                }
                semaphore.signal()
            }
            semaphore.wait()
            
            self.models = models
            self.output.showMovies.accept(models)
            self.output.showLoadingActivity.accept(false)
        }
    }
    
    func getNumberOfSections() -> Int {
        self.output.showMovies.value.count
    }
    
    func getModelType(section at: Int) -> ListMoviesModel.Type {
        type(of: self.output.showMovies.value[at])
    }
    
    func getMovie(section at: Int, row: Int) -> Movie {
        self.output.showMovies.value[at].movies[row]
    }
    
    func getTrackName(section at: Int, row: Int) -> String {
        self.getMovie(section: at, row: row).trackName
    }
    
    func getPrimaryGenreName(section at: Int, row: Int) -> String {
        self.getMovie(section: at, row: row).primaryGenreName
    }
    
    func getContentAdvisoryRating(section at: Int, row: Int) -> String {
        self.getMovie(section: at, row: row).contentAdvisoryRating
    }
    
    func getShortDescription(section at: Int, row: Int) -> String? {
        self.getMovie(section: at, row: row).shortDescription
    }
    
    func getAlbumArt(section at: Int, row: Int, width: Int) -> String {
        self.getMovie(section: at, row: row).artworkUrl100.replacingOccurrences(of: "100x100", with: "\(width)x\(width)")
    }
    
    func getTrackPrice(section at: Int, row: Int) -> String {
        let movie = self.getMovie(section: at, row: row)
        return movie.trackPrice.currencyValue(currencyCode: movie.currency)
    }
    
    func getNumberOfItemsIn(section at: Int) -> Int {
        self.output.showMovies.value[at].movies.count
    }
}

extension ListMoviesViewModel {
    
    struct Input {
        var viewDidLoad: PublishRelay<()>
        var pulledToRefresh: PublishRelay<()>
    }
    
    struct Output {
        var showMovies: BehaviorRelay<[ListMoviesModel]>
        var showLoadingActivity: PublishRelay<(Bool)>
    }
}

