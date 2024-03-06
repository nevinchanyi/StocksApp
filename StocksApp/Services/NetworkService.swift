//
//  NetworkService.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/5/24.
//

import Foundation


protocol NetworkServiceInterface {
    func request<T>(
        endpoint: EndpointInterface
    ) async throws -> T where T: Decodable
}

final class NetworkService: NetworkServiceInterface {
    
    // Constants
    private let tokenId = "roCJZzqTd9RuG4XgmWtm_zJ_bWc4h4aX"
    private let baseURL = "https://api.polygon.io/"
    
    func request<T>(
        endpoint: EndpointInterface
    ) async throws -> T where T: Decodable {
        var components = URLComponents(string: baseURL + endpoint.path)
        components?.queryItems = endpoint.queries

        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.setValue("Bearer " + tokenId, forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decoding(data: String(decoding: data, as: UTF8.self))
        }
    }
}

enum NetworkError: Error {
    case decoding(data: String)
}


// MARK: - MODELS

struct SearchResult: Decodable {
    let results: [Stock]
    
    struct Stock: Decodable, Identifiable {
        let ticker: String
        let name: String

        var id: String {
            ticker
        }
    }
}


struct StockDetails: Decodable, Identifiable {
    let ticker: String
    var results: [StockDetailsByTimestamp] = []
    
    struct StockDetailsByTimestamp: Decodable {
        var openPrice: Double = 0.0
        var closePrice: Double = 0.0
        var highestPrice: Double = 0.0
        var lowestPrice: Double = 0.0
        var timestamp: Int = 0
        var volume: Int = 0
        
        enum CodingKeys: String, CodingKey {
            /** The close price for the symbol in the given time period. */
            case closePrice = "c"
            /** The highest price for the symbol in the given time period. */
            case highestPrice = "h"
            /** The lowest price for the symbol in the given time period. */
            case lowestPrice = "l"
            /** The open price for the symbol in the given time period. */
            case openPrice = "o"
            /** The Unix Msec timestamp for the start of the aggregate window. */
            case timestamp = "t"
            /** The trading volume of the symbol in the given time period. */
            case volume = "v"
        }
        
        var date: Date {
            Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        }
    }
    
    var id: String {
        ticker
    }
    
    var lowestPriceForPeriod: Double {
        results.compactMap({ $0.lowestPrice }).min() ?? 0.0
    }
    
    var highestPriceForPeriod: Double {
        results.compactMap({ $0.highestPrice }).max() ?? 0.0
    }
    
    var volumeEndOfDay: Int {
        results.sorted().last?.volume ?? 0
    }
    
    var openPrice: Double {
        results.sorted().first?.openPrice ?? 0.0
    }
    
    var closePrice: Double {
        results.sorted().last?.closePrice ?? 0.0
    }
}
