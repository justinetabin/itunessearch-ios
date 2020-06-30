//
//  Extensions.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(url: String) {
        self.kf.setImage(with: URL(string: url))
    }
}
