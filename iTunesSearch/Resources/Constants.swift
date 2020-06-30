//
//  Constants.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/29/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

struct Api {
    static var baseUrl = "https://itunes.apple.com"
}

struct Colors {
    static var bg = UIColor.systemBackground
    static var gray = UIColor.systemGray
    static var white = UIColor.white
    static var black = UIColor.black
}

struct Fonts {
    static var large = UIFont.systemFont(ofSize: 25, weight: .bold)
    static var medium = UIFont.systemFont(ofSize: 20, weight: .medium)
    static var small = UIFont.systemFont(ofSize: 15, weight: .regular)
}
