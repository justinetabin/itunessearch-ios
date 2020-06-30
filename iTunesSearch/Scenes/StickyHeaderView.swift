//
//  StickyHeaderView.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class StickyHeaderView: UIView {
    
    private var scrollView: UIScrollView
    private var _stickyHeight: CGFloat
    private var topConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    
    fileprivate func setupConstraints(size: CGSize) {
        self.topConstraint = topAnchor.constraint(equalTo: scrollView.topAnchor)
        self.heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
        self.widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            self.topConstraint!,
            self.heightConstraint!,
            self.widthConstraint!,
        ])
    }
    
    fileprivate func setupSubviews(size: CGSize) {
        self.clipsToBounds = true
        self.scrollView.addSubview(self)
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.contentInset = UIEdgeInsets(top: size.height,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        self.scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.old, .new], context: nil)
    }
    
    init(size: CGSize, scrollView: UIScrollView) {
        self.scrollView = scrollView
        self._stickyHeight = size.height
        super.init(frame: .zero)
        self.setupSubviews(size: size)
        self.setupConstraints(size: size)
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            let yOffset = scrollView.contentOffset.y
            let newOffset = yOffset + self._stickyHeight
            if newOffset >= 0 {
                self.topConstraint?.constant = yOffset - newOffset
                self.heightConstraint?.constant = self._stickyHeight
            } else {
                self.topConstraint?.constant = yOffset
                self.heightConstraint?.constant = self._stickyHeight + (-newOffset)
            }
            self.layoutIfNeeded()
        }
    }
    
    func set(height: CGFloat, width: CGFloat) {
        self._stickyHeight = height
        self.scrollView.contentInset = UIEdgeInsets(top: height,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        self.heightConstraint?.constant = height
        self.widthConstraint?.constant = width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
    }
}
