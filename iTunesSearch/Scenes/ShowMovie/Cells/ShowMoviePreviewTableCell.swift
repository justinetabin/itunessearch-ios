//
//  ShowMoviePreviewTableCell.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 7/1/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import RxSwift

class ShowMoviePreviewTableCell: UITableViewCell {
    static var reuseIdentifier = "ShowMoviePreviewTableCell"
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var playerLayer: AVPlayerLayer = {
        let view = AVPlayerLayer()
        view.videoGravity = .resizeAspectFill
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.containerView)
        self.containerView.layer.addSublayer(self.playerLayer)
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(self.containerView.snp.width).multipliedBy(0.56).priority(.medium)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = self.contentView.bounds
    }
}
