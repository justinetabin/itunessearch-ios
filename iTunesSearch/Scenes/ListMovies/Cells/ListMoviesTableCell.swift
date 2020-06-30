//
//  ListMoviesTableCell.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ListMoviesTableCell: UITableViewCell {
    static var reuseIdentifier = "ListMoviesTableCell"
    
    var artWorkImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var trackNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.font = Fonts.medium
        return view
    }()
    
    var genreLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.small
        return view
    }()
    
    var advisoryRating: UILabel = {
        let view = PaddingLabel()
        view.padding = UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5)
        view.font = Fonts.small
        view.layer.borderColor = Colors.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        return view
    }()
    
    var shorDesc: UILabel = {
        let view = UILabel()
        view.font = Fonts.small
        view.numberOfLines = 6
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.artWorkImageView)
        self.containerView.addSubview(self.trackNameLabel)
        self.containerView.addSubview(self.advisoryRating)
        self.containerView.addSubview(self.genreLabel)
        self.containerView.addSubview(self.shorDesc)
        
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.artWorkImageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        self.trackNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.artWorkImageView.snp.right).offset(10)
            make.top.right.equalToSuperview().inset(10)
        }
        
        self.advisoryRating.snp.makeConstraints { (make) in
            make.left.equalTo(self.trackNameLabel)
            make.top.equalTo(self.trackNameLabel.snp.bottom).offset(5)
        }
        
        self.genreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.advisoryRating.snp.left)
            make.right.equalTo(self.trackNameLabel.snp.right)
            make.top.equalTo(self.advisoryRating.snp.bottom).offset(5)
        }
        
        self.shorDesc.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.trackNameLabel)
            make.top.equalTo(self.genreLabel.snp.bottom).offset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
