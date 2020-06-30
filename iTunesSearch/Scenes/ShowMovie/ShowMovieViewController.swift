//
//  ShowMovieViewController.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import AVKit

class ShowMovieViewController: BaseViewController<ShowMovieViewModel> {
    
    var tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    var player: AVPlayer?
    
    lazy var stickyHeaderView: ShowMovieStickyHeaderView = {
        let screen = UIScreen.main.bounds
        let width = screen.width
        let height = screen.height * 0.5
        let view = ShowMovieStickyHeaderView(size: CGSize(width: width,
                                                          height: height),
                                             scrollView: self.tableView)
        return view
    }()
    
    fileprivate func setupSubviews() {
        self.view.addSubview(self.tableView)        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func bindViews() {
        self.viewModel.output.showMovie
            .observeOn(MainScheduler.instance)
            .bind { [weak self] (_) in
                guard let self = self else { return }
                self.setStickyHeader()
                self.tableView.reloadData()
        }.disposed(by: self.disposeBag)
        
        self.viewModel.output.playPreview
            .observeOn(MainScheduler.instance)
            .bind { [weak self] (_) in
                guard let self = self else { return }
                self.playPlayer(url: self.viewModel.movie.previewUrl)
            }.disposed(by: self.disposeBag)
    }
    
    fileprivate func setStickyHeader() {
        let width = self.view.frame.width
        self.stickyHeaderView.albumArtImageView.setImage(url: self.viewModel.getAlbumArt(with: Int(width)))
        self.stickyHeaderView.trackNameLabel.text = self.viewModel.movie.trackName
        self.stickyHeaderView.detailsLabel.text = self.viewModel.getFormattedDetails()
        self.stickyHeaderView.advisoryRating.text = self.viewModel.movie.contentAdvisoryRating
        self.stickyHeaderView.priceLabel.text = self.viewModel.getTrackPrice()
        self.stickyHeaderView.yearLabel.text = self.viewModel.getReleaseYear()
    }
    
    fileprivate func setupTableView() {
        self.tableView.register(ShowMovieAboutTableCell.self, forCellReuseIdentifier: ShowMovieAboutTableCell.reuseIdentifier)
        self.tableView.register(ShowMoviePreviewTableCell.self, forCellReuseIdentifier: ShowMoviePreviewTableCell.reuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    fileprivate func playPlayer(url: String) {
        self.player = AVPlayer(url: URL(string: url)!)
        self.player?.playImmediately(atRate: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.bindViews()
        self.setupTableView()
        self.viewModel.input.viewDidLoad.accept(())
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.setStickyHeight(size: size)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.pause()
        self.player = nil
    }

    func setStickyHeight(size: CGSize) {
        let height = size.height * 0.5
        self.stickyHeaderView.set(height: height, width: size.width)
    }
}

extension ShowMovieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoviePreviewTableCell.reuseIdentifier, for: indexPath) as! ShowMoviePreviewTableCell
            cell.playerLayer.player = self.player
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowMovieAboutTableCell.reuseIdentifier, for: indexPath) as! ShowMovieAboutTableCell
            cell.bodyLabel.attributedText = self.viewModel.movie.longDescription.lineSpaced(4)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
