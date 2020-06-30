//
//  ShowMovieAboutTableCell.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ShowMovieAboutTableCell: UITableViewCell {
    
    static var reuseIdentifier = "ShowMovieAboutTableCell"
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "About the movie"
        view.font = Fonts.medium
        return view
    }()
    
    var bodyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.bodyLabel)
        
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        
        self.bodyLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
