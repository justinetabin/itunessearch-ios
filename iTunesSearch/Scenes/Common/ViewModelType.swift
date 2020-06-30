//
//  ViewModelType.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol ViewModelType: class {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
