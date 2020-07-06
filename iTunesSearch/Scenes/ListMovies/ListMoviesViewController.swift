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
    
    static var horizontalLayoutSection: NSCollectionLayoutSection = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                                                                          heightDimension: .fractionalWidth(0.33 * 1.5)),
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.bottom = 50
        return section
    }()
    
    static var verticalLayoutSection: NSCollectionLayoutSection = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .fractionalWidth(0.33 * 1.5)),
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }()
    
    lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, env) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let type = self.viewModel.getModelType(section: sectionIndex)
            if type == ListMoviesSearched.self {
                return ListMoviesViewController.verticalLayoutSection
            } else {
                return ListMoviesViewController.horizontalLayoutSection
            }
        }
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.compositionalLayout)
        view.backgroundColor = UIColor.systemBackground
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
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.loadingActivityIndicatorView)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.loadingActivityIndicatorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.register(ListMoviesCollectionCell.self, forCellWithReuseIdentifier: ListMoviesCollectionCell.reuseIdentifier)
        self.collectionView.register(ListMoviesBrowsedMovieCollectionCell.self, forCellWithReuseIdentifier: ListMoviesBrowsedMovieCollectionCell.reuseIdentifier)
        self.collectionView.refreshControl = self.pullToRefreshControl
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
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
            .skip(1)
            .observeOn(MainScheduler.asyncInstance)
            .bind { [weak self] (models) in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }.disposed(by: self.disposeBag)
        
        self.viewModel.output.showMovies
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .bind { (_) in
                self.pullToRefreshControl.endRefreshing()
            }.disposed(by: self.disposeBag)
        
        self.viewModel.output.showLoadingActivity
            .observeOn(MainScheduler.instance)
            .bind { [weak self] (loading) in
                guard let self = self else { return }
                if loading {
                    self.loadingActivityIndicatorView.startAnimating()
                    self.loadingActivityIndicatorView.isHidden = false
                    self.collectionView.isHidden = true
                } else {
                    self.loadingActivityIndicatorView.stopAnimating()
                    self.loadingActivityIndicatorView.isHidden = true
                    self.collectionView.isHidden = false
                }
            }.disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupCollectionView()
        self.bindViews()
        self.viewModel.input.viewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNav()
    }
}

extension ListMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.viewModel.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.getNumberOfItemsIn(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = self.viewModel.getModelType(section: indexPath.section)
        if type == ListMoviesSearched.self {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListMoviesCollectionCell.reuseIdentifier, for: indexPath) as! ListMoviesCollectionCell
            let width = Int(collectionView.frame.width)
            cell.artWorkImageView.setImage(url: self.viewModel.getAlbumArt(section: indexPath.section, row: indexPath.row, width: width))
            cell.trackNameLabel.text = self.viewModel.getTrackName(section: indexPath.section, row: indexPath.row)
            cell.genreLabel.text = self.viewModel.getPrimaryGenreName(section: indexPath.section, row: indexPath.row)
            cell.advisoryRating.text = self.viewModel.getContentAdvisoryRating(section: indexPath.section, row: indexPath.row)
            cell.shorDesc.attributedText = self.viewModel.getShortDescription(section: indexPath.section, row: indexPath.row)?.lineSpaced(4)
            cell.priceLabel.text = self.viewModel.getTrackPrice(section: indexPath.section, row: indexPath.row)
            return cell
        } else if type == ListMoviesBrowsed.self {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListMoviesBrowsedMovieCollectionCell.reuseIdentifier, for: indexPath) as! ListMoviesBrowsedMovieCollectionCell
            let width = Int(collectionView.frame.width)
            cell.artWorkImageView.setImage(url: self.viewModel.getAlbumArt(section: indexPath.section, row: indexPath.row, width: width))
            cell.trackNameLabel.text = self.viewModel.getTrackName(section: indexPath.section, row: indexPath.row)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.viewModel.getMovie(section: indexPath.section, row: indexPath.row)
        let showMovieScene = self.factory.makeShowMovieScene(movie: movie)
        self.show(showMovieScene, sender: nil)
    }
    
}
