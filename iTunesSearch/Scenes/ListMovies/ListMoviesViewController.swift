//
//  ListMoviesViewController.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class ListMoviesViewController: BaseViewController<ListMoviesViewModel> {
    
    var tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    var pullToRefreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        return view
    }()
    
    fileprivate func setupSubviews() {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupTableView() {
        self.tableView.refreshControl = self.pullToRefreshControl
        self.tableView.register(ListMoviesTableCell.self, forCellReuseIdentifier: ListMoviesTableCell.reuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    fileprivate func bindViews() {
        self.pullToRefreshControl.rx.controlEvent(.valueChanged)
            .observeOn(MainScheduler.instance)
            .bind(to: self.viewModel.input.pulledToRefresh)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.showMovies
            .observeOn(MainScheduler.instance)
            .bind { [weak self] (_) in
                self?.pullToRefreshControl.endRefreshing()
                self?.tableView.reloadData()
            }.disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
        self.setupTableView()
        self.bindViews()
        self.viewModel.input.viewDidLoad.accept(())
    }
}

extension ListMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListMoviesTableCell.reuseIdentifier, for: indexPath) as! ListMoviesTableCell
        let width = tableView.frame.width
        let rowIndex = indexPath.row
        let movie = self.viewModel.movies[rowIndex]
        cell.artWorkImageView.setImage(url: self.viewModel.getAlbumArt(at: rowIndex, with: width))
        cell.trackNameLabel.text = movie.trackName
        cell.genreLabel.text = movie.primaryGenreName
        cell.advisoryRating.text = movie.contentAdvisoryRating
        cell.shorDesc.text = movie.shortDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = Int(tableView.frame.width / 3)
        return CGFloat(width) * 1.5
    }
}
