//
//  StocksOverviewViewModel.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/6/24.
//

import Foundation


final class StocksOverviewViewModel: ObservableObject {
        
    var storage: StockDataStorage?
    
    func refresh() async {
        let networkService: NetworkServiceInterface = NetworkService()
        do {
            for stock in storage?.stocks ?? [] {
                let stockDetails: StockDetails = try await networkService.request(
                    endpoint: StockEndpoint.getStockDetails(ticker: stock.ticker,
                                                            fromDate: "2023-01-09",
                                                            toDate: "2023-01-09")
                )
                await storage?.updateData(for: stockDetails)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
