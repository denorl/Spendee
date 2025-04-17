//
//  StatsScreen.swift
//  Spendee
//
//  Created by Denis's MacBook on 20/3/25.
//

import SwiftUI
import Charts
import SwiftData

struct StatsScreen: View {
    
    @Query(animation: .snappy) private var transactions: [Transaction]
    
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var currentDate: Date = .now
    @State private var selectedType: TransactionType = .income
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        
                        SegmentedControlView(selectedType: $selectedType)
                            .padding(.horizontal, 10)
                        
                        VStack {

                            DateSection()
                            
                            ChartView(selectedType: $selectedType, startDate: $startDate, endDate: $endDate)
                            
                        }
                        .padding()
                        
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.elementsBackground)
                                .shadow(radius: 0.5)
                        }
                        .padding(10)
                        
                        FilterTransactionsView(startDate: startDate, endDate: endDate, transactionType: selectedType) { transactions in
                            
                            CategorySections(transactions: transactions)
                            
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HeaderView(header: "Statistics", headerSize: 50, headerFontDesign: .serif)
                }
            }
        }
}
}


#Preview(traits: .sampleTransactionData) {
    StatsScreen()
}

extension StatsScreen {
    private func changeCurrentMonth(by value: Int) {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = date
            startDate = currentDate.startOfMonth
            endDate = currentDate.endOfMonth
        }
    }
    
    private func mapTransactions (transactions: [Transaction]) -> [String] {
     
        return transactions.map { $0.category }
    }
    
    @ViewBuilder
    private func DateSection() -> some View {
        HStack {
            Button {
                changeCurrentMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.accent)
            }
            Spacer()
            Text("\(startDate.dateAsString()) - \(endDate.dateAsString())")
                .font(.system(.title3, design: .serif))
                .foregroundStyle(.accent.opacity(0.5))
            Spacer()
            
            Button {
                changeCurrentMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.accent)
            }
            
            
        }
    }
    
    @ViewBuilder
    private func CategorySections(transactions: [Transaction]) -> some View {
        let categories = mapTransactions(transactions: transactions)
        
        ForEach(categories, id: \.self) { category in
            Section {
                if let filteredTransaction = transactions.first(where: { $0.category == category }) {
                    TransactionCardView(transaction: filteredTransaction) {
                    }
                }
            } header: {
                Text(category)
                    .foregroundStyle(.secondaryText)
                    .bold()
                    .shadow(radius: 0.2)
                
            }
        }
    }
}
