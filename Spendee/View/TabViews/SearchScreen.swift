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
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
                    Section {
                        SearchBarView(searchText: $searchText, headerIsVisible: $headerIsVisible)
                        FilterTransactionsView(searchText: searchText, transactionType: selectedType) { transactions in
                            ForEach(transactions) { transaction in
                                TransactionCardView(transaction: transaction)
                            }
                        }
                    } header: { 
                        if headerIsVisible {
                            
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
                           
                            

                        }
                    }
                }
                .padding(15)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
                searchText = ""
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
    
    
}
