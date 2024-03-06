//
//  StockEndpoint.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/5/24.
//

import Foundation

protocol EndpointInterface {
    var path: String { get }
    var queries: [URLQueryItem] { get }
}

enum StockEndpoint: EndpointInterface {
    case search(ticker: String)
    case getStockDetails(ticker: String, fromDate: String, toDate: String)
    
    var path: String {
        switch self {
        case .search:
            return "v3/reference/tickers"
        case .getStockDetails(let ticker, let fromDate, let toDate):
            return "v2/aggs/ticker/\(ticker)/range/1/hour/\(fromDate)/\(toDate)"
        }
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .search(let ticker):
            return [URLQueryItem(name: "search", value: ticker)]
        case .getStockDetails:
            return [URLQueryItem(name: "adjusted", value: "false"), URLQueryItem(name: "include_otc", value: "false"), URLQueryItem(name: "limit", value: "5000")]
        }
    }
}
