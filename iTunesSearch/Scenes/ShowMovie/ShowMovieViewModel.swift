//
//  ShowMovieViewModel.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxRelay

class ShowMovieViewModel: BaseViewModel, ViewModelType {
    
    var input = Input(
        viewDidLoad: PublishRelay()
    )
    
    var output = Output(
        showMovie: PublishRelay(),
        playPreview: PublishRelay()
    )
    
    var worker: CacheMovieDecorator
    private var movie: Movie
    
    init(movie: Movie, worker: CacheMovieDecorator) {
        self.movie = movie
        self.worker = worker
        super.init()
        
        self.input.viewDidLoad.bind { [weak self] (_) in
            guard let self = self else { return }
            self.output.showMovie.accept(())
            self.worker.getMovie(trackId: self.movie.trackId) { (movie) in
                if let gotMovie = movie {
                    self.movie = gotMovie
                    self.output.playPreview.accept(())
                    self.output.showMovie.accept(())
                } else {
                    // TODO: Handle when failed to fetch movie &
                    //       Without local data
                }
            }
        }.disposed(by: self.disposeBag)
    }
    
    func getPreviewUrl() -> String {
        return self.movie.previewUrl
    }
    
    func getTrackName() -> String {
        return self.movie.trackName
    }
    
    func getContentAdvisoryRating() -> String {
        return self.movie.contentAdvisoryRating
    }
    
    func getLongDescription() -> String {
        return self.movie.longDescription
    }
    
    func getAlbumArt(with width: Int) -> String {
        return self.movie.artworkUrl100.replacingOccurrences(of: "100x100", with: "\(width)x\(width)")
    }
    
    func getFormattedDetails() -> String {
        return "| \(self.movie.primaryGenreName) | \(self.movie.country)"
    }
    
    func getReleaseYear() -> String {
        if let date = self.movie.releaseDate.toDate() {
            return "\(date.toString()) • \(self.getTrackTimeInHour())"
        }
        return ""
    }
    
    func getTrackTimeInHour() -> String {
        let seconds = self.movie.trackTimeMillis / 1000
        let time = seconds.toHoursMinutesSeconds(seconds: seconds)
        var timeInString = ""
        if time.0 > 0 {
            timeInString += "\(time.0)h "
        }
        if time.1 > 0 {
            timeInString += "\(time.1)m"
        }
        return timeInString
    }
    
    func getTrackPrice() -> String {
        return self.movie.trackPrice.currencyValue(currencyCode: self.movie.currency)
    }
}

extension ShowMovieViewModel {
    
    struct Input {
        var viewDidLoad: PublishRelay<()>
    }
    
    struct Output {
        var showMovie: PublishRelay<()>
        var playPreview: PublishRelay<()>
    }
}
