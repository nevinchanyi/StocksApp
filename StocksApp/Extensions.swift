//
//  Extensions.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/6/24.
//

import Foundation

extension Array where Element == StockDetails {
    subscript(details: StockDetails) -> Int? {
        self.firstIndex(where: { $0.id == details.ticker })
    }
}

extension Array where Element == StockDetails.StockDetailsByTimestamp {
    func sorted() -> [StockDetails.StockDetailsByTimestamp] {
        self.sorted(by: { $0.timestamp > $1.timestamp })
    }
}

extension Double {
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: self as NSNumber) ?? ""
    }
}

extension Int {
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
