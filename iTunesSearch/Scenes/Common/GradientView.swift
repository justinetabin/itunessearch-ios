//
//  GradientView.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    var gradient = CAGradientLayer()
    
    init(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]) {
        super.init(frame: .zero)
        layer.insertSublayer(gradient, at: 0)
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = locations
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
