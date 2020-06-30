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
        showMovies: PublishRelay()
    )
    
    var worker: CacheMovieDecorator
    var movies = [Movie]()
    
    init(worker: CacheMovieDecorator) {
        self.worker = worker
        super.init()
        
        self.input.viewDidLoad.bind { [weak self] (_) in
            guard let self = self else { return }
            self.worker.searchMovies { (movies) in
                if let movies = movies {
                    self.movies = movies
                    self.output.showMovies.accept(())
                }
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
    
    func getAlbumArt(at index: Int, with width: CGFloat) -> String {
        let width = Int(width)
        return self.movies[index].artworkUrl100.replacingOccurrences(of: "100x100", with: "\(width)x\(width)")
    }
}

extension ListMoviesViewModel {
    
    struct Input {
        var viewDidLoad: PublishRelay<()>
        var pulledToRefresh: PublishRelay<()>
    }
    
    struct Output {
        var showMovies: PublishRelay<()>
    }
}
