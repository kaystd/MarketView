//
//  StockListView.swift
//  MarketView
//
//  Created by Данил Кайст on 23.06.2025.
//

import SwiftUI


struct StockListView: View {
    var viewModel: any StockListViewModel

    var body: some View {
        List {
            Section {
                HStack {
                    VStack {
                        Text("Ticker")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .fontWeight(.bold)
                    VStack {
                        Text("Price")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .fontWeight(.bold)
                    VStack {
                        Text("Daily change")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .fontWeight(.bold)
                }
                .padding()
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    return 0
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                ForEach(viewModel.stocks) { stock in
                    HStack {
                        VStack {
                            Text(stock.ticker)
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        VStack {
                            Text(stock.price)
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        VStack {
                            Text(stock.change)
                                .foregroundStyle(stock.change.contains("-") ? .red : .green)
                        }.frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .padding()
                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                        return 0
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }

        .onAppear(){
            self.viewModel.didUpdate()
        }
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView(viewModel: previewViewModel())
    }

    class previewViewModel: StockListViewModel {
        var stocks = [
            StockListItemViewModel(stock: Stock(ticker: "Apple", price: 110.02, change: 2.37) ),
            StockListItemViewModel(stock: Stock(ticker: "Google", price: 4323.12, change: 0.14) ),
            StockListItemViewModel(stock: Stock(ticker: "Meta", price: 45.98, change: -5.89) ),
        ]
        var loading = false
        var errorMessage = ""
        func didUpdate() {}
        func didCancel() {}
    }
}
