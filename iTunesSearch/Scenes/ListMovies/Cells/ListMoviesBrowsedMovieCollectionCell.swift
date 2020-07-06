//
//  ListMoviesBrowsedMovieCollectionCell.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 7/5/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ListMoviesBrowsedMovieCollectionCell: UICollectionViewCell {
    static var reuseIdentifier = "ListMoviesBrowsedMovieCollectionCell"
    
    var artWorkImageView: PlaceholderImageView = {
        let view = PlaceholderImageView(frame: .zero)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var trackNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = Fonts.medium
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
    
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.artWorkImageView)
        self.containerView.addSubview(self.trackNameLabel)
        
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.artWorkImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(self.containerView.snp.width).multipliedBy(1.5)
        }
        
        self.trackNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.artWorkImageView.snp.bottom).offset(10).priority(.low)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
