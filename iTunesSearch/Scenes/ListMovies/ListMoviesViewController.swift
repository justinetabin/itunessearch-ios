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
    
    var loadingActivityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    fileprivate func setupSubviews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.loadingActivityIndicatorView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.loadingActivityIndicatorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupTableView() {
        self.tableView.refreshControl = self.pullToRefreshControl
        self.tableView.register(ListMoviesTableCell.self, forCellReuseIdentifier: ListMoviesTableCell.reuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()

    }
    
    fileprivate func setupNav() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = Colors.gray
        self.title = "iTunesSearch"
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
        
        self.viewModel.output.showLoadingActivity
            .observeOn(MainScheduler.instance)
            .bind { [weak self] (loading) in
                guard let self = self else { return }
                if loading {
                    self.loadingActivityIndicatorView.startAnimating()
                    self.loadingActivityIndicatorView.isHidden = false
                    self.tableView.isHidden = true
                } else {
                    self.loadingActivityIndicatorView.stopAnimating()
                    self.loadingActivityIndicatorView.isHidden = true
                    self.tableView.isHidden = false
                }
            }.disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
        self.setupTableView()
        self.bindViews()
        self.viewModel.input.viewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNav()
    }
}

extension ListMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getMovies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListMoviesTableCell.reuseIdentifier, for: indexPath) as! ListMoviesTableCell
        let width = tableView.frame.width
        let rowIndex = indexPath.row
        let viewModel = self.viewModel
        cell.artWorkImageView.setImage(url: viewModel.getAlbumArt(at: rowIndex, with: Int(width)))
        cell.trackNameLabel.text = viewModel.getTrackName(at: rowIndex)
        cell.genreLabel.text = viewModel.getPrimaryGenreName(at: rowIndex)
        cell.advisoryRating.text = viewModel.getContentAdvisoryRating(at: rowIndex)
        cell.shorDesc.attributedText = viewModel.getShortDescription(at: rowIndex)?.lineSpaced(4)
        cell.priceLabel.text = viewModel.getTrackPrice(at: rowIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = Int(tableView.frame.width / 3)
        return CGFloat(width) * 1.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = self.viewModel.getMovies()[indexPath.row]
        let showMovieScene = self.factory.makeShowMovieScene(movie: movie)
        self.show(showMovieScene, sender: nil)
    }
}
