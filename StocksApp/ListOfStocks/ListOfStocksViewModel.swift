//
//  ListOfStocksViewModel.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/6/24.
//

import Foundation


final class ListOfStocksViewModel: ObservableObject {
    
    @Published var showSearchView = false
    
    var storage: StockDataStorage?
    
    
    func remove(at offsets: IndexSet) {
        storage?.stocks.remove(atOffsets: offsets)
    }
}
