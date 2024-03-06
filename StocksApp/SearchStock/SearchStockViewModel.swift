//
//  SearchStockViewModel.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/6/24.
//

import Foundation
import Combine

final class SearchStockViewModel: ObservableObject {
    
    @Published var searchStock = ""
    @Published var stockSearchResults: [SearchResult.Stock] = []
    
    let networkService: NetworkServiceInterface
    
    var storage: StockDataStorage?
    
    private var cancellable: AnyCancellable?
    
    init(networkService: NetworkServiceInterface = NetworkService()) {
        self.networkService = networkService
        observeSearchChanges()
    }
    
    private func observeSearchChanges() {
        cancellable = $searchStock
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] stock in
                guard !stock.isEmpty else { return }
                self?.search(for: stock)
            })
    }
    
    private func search(for ticker: String) {
        Task {
            do {
                let searchResult: SearchResult = try await networkService.request(
                    endpoint: StockEndpoint.search(ticker: ticker)
                )
                await MainActor.run {
                    stockSearchResults = searchResult.results
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func add(stock: SearchResult.Stock, completion: @escaping (() -> Void)) {
        Task {
            do {
                let stockDetails: StockDetails = try await networkService.request(
                    endpoint: StockEndpoint.getStockDetails(ticker: stock.ticker,
                                                            fromDate: "2023-01-09",
                                                            toDate: "2023-01-09")
                )
                await storage?.add(stock: stockDetails)
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
