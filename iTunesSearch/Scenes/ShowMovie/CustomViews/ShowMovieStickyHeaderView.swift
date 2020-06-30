//
//  ShowMovieStickyHeaderView.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class ShowMovieStickyHeaderView: StickyHeaderView {
    
    var gradientView: GradientView = {
        let view = GradientView(colors: [UIColor.clear, UIColor.black],
                                startPoint: CGPoint(x: 0.5, y: 0.0),
                                endPoint: CGPoint(x: 0.5, y: 1.0),
                                locations: [0, 1])
        return view
    }()
    
    var albumArtImageView: PlaceholderImageView = {
        let view = PlaceholderImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var trackNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.font = Fonts.large
        view.textColor = Colors.white
        return view
    }()
    
    var detailsLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.medium
        view.textColor = Colors.white
        return view
    }()
    
    var advisoryRating: UILabel = {
        let view = PaddingLabel()
        view.padding = UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5)
        view.font = Fonts.medium
        view.layer.borderColor = Colors.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        view.textColor = Colors.white
        return view
    }()
    
    var priceLabel: PaddingLabel = {
        let view = PaddingLabel()
        view.padding = UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5)
        view.font = Fonts.medium
        view.textColor = Colors.white
        view.layer.borderColor = Colors.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        return view
    }()
    
    var yearLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.medium
        view.textColor = Colors.white
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(size: CGSize, scrollView: UIScrollView) {
        super.init(size: size, scrollView: scrollView)
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.albumArtImageView)
        self.containerView.addSubview(self.gradientView)
        self.containerView.addSubview(self.trackNameLabel)
        self.containerView.addSubview(self.detailsLabel)
        self.containerView.addSubview(self.advisoryRating)
        self.containerView.addSubview(self.priceLabel)
        self.containerView.addSubview(self.yearLabel)
        
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.gradientView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self.albumArtImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.trackNameLabel.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.equalToSuperview().inset(10)
            make.bottom.equalTo(self.yearLabel.snp.top).offset(-10)
        }
        
        self.yearLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.trackNameLabel)
            make.bottom.equalTo(self.detailsLabel.snp.top).offset(-10)
        }
        
        self.detailsLabel.snp.contentHuggingHorizontalPriority = 250
        self.detailsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.advisoryRating.snp.right).offset(10).priority(.medium)
            make.right.equalTo(self.trackNameLabel)
            make.centerY.equalTo(self.advisoryRating)
        }
        
        self.advisoryRating.snp.contentHuggingHorizontalPriority = 251
        self.advisoryRating.snp.makeConstraints { (make) in
            make.left.equalTo(self.trackNameLabel)
            make.bottom.equalTo(self.priceLabel.snp.top).offset(-10)
        }
        
        self.priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.trackNameLabel)
            make.bottom.equalToSuperview().offset(-20)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
