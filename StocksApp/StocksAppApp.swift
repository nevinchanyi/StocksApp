//
//  StocksAppApp.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/4/24.
//

import SwiftUI

@main
struct StocksAppApp: App {
    @StateObject private var storage = StockDataStorage(stocks: [
        StockDetails(ticker: "AAPL") // DEMO STOCK
    ])
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StocksOverviewView()
            }
            .navigationViewStyle(.stack)
            .environmentObject(storage)
        }
    }
}


final class StockDataStorage: ObservableObject {
    
    @Published var stocks: [StockDetails] = []
    
    
    init(stocks: [StockDetails] = []) {
        self.stocks = stocks
    }
    
    @MainActor
    func updateData(for stock: StockDetails) async {
        if let index = stocks[stock] {
            stocks[index] = stock
        }
    }
    
    @MainActor
    func add(stock: StockDetails) async {
        guard !stocks.contains(where: { $0.id == stock.id }) else { return }
        stocks.append(stock)
    }
}
