//
//  StockDetailView.swift
//  StocksApp
//
//  Created by Kostiantyn Nevinchanyi on 3/5/24.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    
    var stock: StockDetails
    @StateObject private var viewModel = StockDetailViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, content: {
                Text("Volume: \(stock.volumeEndOfDay.currencyFormatted)")
                Text("Lowest: \(stock.lowestPriceForPeriod.currencyFormatted)")
                    .modifier(SecondaryText())
                Text("Highest: \(stock.highestPriceForPeriod.currencyFormatted)")
                    .modifier(SecondaryText())
            })
            .padding(.leading)
            
            Divider()
            
            Chart {
                ForEach(stock.results.sorted(), id: \.timestamp) { stockDetail in
                    LineMark(
                        x: .value("Time", stockDetail.date, unit: .hour, calendar: .current),
                        y: .value("Price", stockDetail.highestPrice)
                    )
                }
                .foregroundStyle(.green)
            }
            .chartYScale(domain: stock.lowestPriceForPeriod...stock.highestPriceForPeriod)
        }
        .navigationTitle(stock.ticker)
    }
}

#Preview {
    StockDetailView(stock: StockDetails(ticker: "AAPL"))
}
