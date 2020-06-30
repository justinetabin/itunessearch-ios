//
//  Extensions.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/30/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import Kingfisher

extension Double {
    func currencyValue(currencyCode: String = "USD") -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.currencyCode = currencyCode
        var value = "0.00"
        if let string = currencyFormatter.string(from: NSNumber(value: self)) {
            value = string
        }
        return value
    }
}

extension Date {
    func toString(dateFormat: String = "yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    func toDate(dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
    
    func lineSpaced(_ spacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributedString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return attributedString
    }
}

extension UIImageView {
    func setImage(url: String) {
        let options = KingfisherOptionsInfo(arrayLiteral: .transition(ImageTransition.fade(0.3)))
        self.kf.setImage(with: URL(string: url), options: options)
    }
}

extension Int {
    func toHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
