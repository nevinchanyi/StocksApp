//
//  ContentView.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/4/24.
//

import SwiftUI

struct StocksOverviewView: View {
    
    @EnvironmentObject var storage: StockDataStorage
    @StateObject private var viewModel = StocksOverviewViewModel()
    
    var body: some View {
        List {
            if storage.stocks.isEmpty {
                Text("No stocks to display. Add one.")
            } else {
                ForEach(storage.stocks) { stock in
                    if stock.results.isEmpty {
                        ProgressView()
                    } else {
                        NavigationLink {
                            StockDetailView(stock: stock)
                        } label: {
                            StockOverviewCellView(stock: stock)
                        }
                    }
                }
            }
        }
        .navigationTitle("Stocks Overview")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ListOfStocksView()
                        .environmentObject(storage)
                } label: {
                    Text("List of stocks")
                }
            }
        }
        .refreshable {
            Task {
                await viewModel.refresh()
            }
        }
        .task {
            viewModel.storage = storage
            await viewModel.refresh()
        }
    }
}

#Preview {
    StocksOverviewView()
        .environmentObject(StockDataStorage())
}


fileprivate struct StockOverviewCellView: View {
    
    let stock: StockDetails
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(stock.ticker)
                .bold()
            Text("Open price: \(stock.openPrice.currencyFormatted)")
                .modifier(SecondaryText())
            Text("Close price: \(stock.closePrice.currencyFormatted)")
                .modifier(SecondaryText())
        }
    }
}
