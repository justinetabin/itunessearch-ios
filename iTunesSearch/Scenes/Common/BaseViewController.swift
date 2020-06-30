//
//  BaseViewController.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BaseViewController<ViewModel: ViewModelType>: ViewController {
    var factory: ViewControllerFactory
    var viewModel: ViewModel
    var disposeBag = DisposeBag()
    
    init(factory: ViewControllerFactory, viewModel: ViewModel) {
        self.factory = factory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = Colors.bg
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
