//
//  SearchScreen.swift
//  Spendee
//
//  Created by Denis's MacBook on 20/3/25.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var searchText: String = ""
    @State private var headerIsVisible: Bool = true
    @State private var isShowingFilterView: Bool = false
    @State private var selectedType: TransactionType? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        //MARK: - Search Bar
                        SearchBarView(searchText: $searchText, headerIsVisible: $headerIsVisible)
                        
                        //MARK: - Transaction Cards
                        FilterTransactionsView(searchText: searchText, transactionType: selectedType) { transactions in
                            ForEach(transactions) { transaction in
                                TransactionCardView(transaction: transaction, actions: {
                                    
                                })
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    searchText = ""
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                        ToolbarHeader()
                }
            }
        
    }
    }
}

#Preview(traits: .sampleTransactionData) {
    SearchScreen()
}



extension SearchScreen {
    @ViewBuilder
    func FilerMenuView() -> some View {
        Button {
            selectedType = nil
        } label: {
            HStack {
                Text("Both")
                
                if selectedType == nil {
                    Image(systemName: "checkmark")
                }
            }
        }
        
        ForEach(TransactionType.allCases, id: \.self) { type in
            Button {
                selectedType = type
            } label: {
                HStack {
                    Text(type.rawValue)
                    if selectedType == type {
                        Image(systemName: "checkmark")
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    private func ToolbarHeader() -> some View {
        HeaderView(header: "Search", headerSize: 50, headerFontDesign: .serif) {
            Menu {
                FilerMenuView()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.white)
                    .background {
                        Capsule()
                            .rotationEffect(Angle(degrees: 180))
                            .frame(width: 45, height: 60)
                            .foregroundStyle(.accent)
                    }
            }
        }
        .padding(.top, 35)

    }
}
