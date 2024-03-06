//
//  ListOfStocksView.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/5/24.
//

import SwiftUI

struct ListOfStocksView: View {
    
    @EnvironmentObject var storage: StockDataStorage
    
    @StateObject private var viewModel = ListOfStocksViewModel()
    
    var body: some View {
        List {
            if storage.stocks.isEmpty {
                Text("No stocks found. Add one.")
            } else {
                Section {
                    ForEach(storage.stocks) { stock in
                        VStack(alignment: .leading) {
                            Text(stock.ticker)
                        }
                    }
                    .onDelete(perform: viewModel.remove(at:))
                } footer: {
                    Text("Swipe left to delete")
                }
            }
        }
        .navigationTitle("List of stocks")
        .sheet(isPresented: $viewModel.showSearchView, content: {
            SearchStockView(showSearchView: $viewModel.showSearchView)
                .environmentObject(storage)
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showSearchView = true
                } label: {
                    Text("Add Stock")
                }
            }
        }
        .task {
            viewModel.storage = storage
        }
    }
}

#Preview {
    ListOfStocksView()
        .environmentObject(StockDataStorage())
}
