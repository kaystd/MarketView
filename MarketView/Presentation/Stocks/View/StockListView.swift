//
//  StockListView.swift
//  MarketView
//
//  Created by Данил Кайст on 23.06.2025.
//

import SwiftUI


struct StockListView<ViewModel: StockListViewModel>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        Group {
            if viewModel.loading {
                ProgressView("Loading...")
                .controlSize(.large)
            } else {
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
                        ForEach(viewModel.stocks, id: \.ticker) { stock in
                            HStack {
                                VStack {
                                    Text(stock.ticker)
                                }.frame(minWidth: 0, maxWidth: .infinity)
                                VStack {
                                    AnimatedText(text: stock.price)
                                        .id(stock.ticker)
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
            }
        }
        .onAppear(){
            self.viewModel.didUpdate()
        }
        .onDisappear() {
            self.viewModel.didCancel()
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
