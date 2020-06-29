//
//  StoreResult.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/29/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

struct StoreResult<T: Codable>: Codable {
    var resultCount: Int
    var results: T
}
