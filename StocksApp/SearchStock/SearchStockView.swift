//
//  SearchStockView.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/5/24.
//

import SwiftUI

struct SearchStockView: View {
    
    @EnvironmentObject var storage: StockDataStorage
    
    @StateObject private var viewModel = SearchStockViewModel()
    
    @Binding var showSearchView: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("AAPL, Apple Inc.", text: $viewModel.searchStock)
                        .autocorrectionDisabled()
                } header: {
                    Text("Search")
                }
                
                Section {
                    if viewModel.stockSearchResults.isEmpty {
                        Text("Start searching..")
                    } else {
                        ForEach(viewModel.stockSearchResults) { stock in
                            Button(action: {
                                viewModel.add(stock: stock, completion: {
                                    showSearchView = false
                                })
                            }, label: {
                                VStack(alignment: .leading) {
                                    Text(stock.ticker)
                                        .bold()
                                    Text(stock.name)
                                        .modifier(SecondaryText())
                                }
                            })
                        }
                    }
                } header: {
                    Text("Search results")
                }
            }
            .navigationTitle("Add Stock")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.storage = storage
            }
        }
    }
}

#Preview {
    SearchStockView(showSearchView: .constant(true))
        .environmentObject(StockDataStorage())
}


struct SecondaryText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundStyle(Color.gray)
    }
}
