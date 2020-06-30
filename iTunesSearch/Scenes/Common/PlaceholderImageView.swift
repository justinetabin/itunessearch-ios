//
//  PlaceholderImageView.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PlaceholderImageView: UIImageView {
    
    override var image: UIImage? {
        didSet {
            if self.image != nil {
                self.placeholderImageView.isHidden = true
            } else {
                self.placeholderImageView.isHidden = false
            }
        }
    }
    
    var placeholderImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "placeholder_image"))
        view.contentMode = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.placeholderImageView)
        self.placeholderImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
