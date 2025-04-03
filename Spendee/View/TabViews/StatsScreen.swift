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
    
    @State private var chartGroups: [ChartGroup] = []
    
    @State private var selectedType: TransactionType = .income
    
    @State private var rawSelectedDate: Date?
    
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    Section {
                        if !chartGroups.isEmpty {
                            SegmentedControlView(selectedType: $selectedType)
                                .padding(.horizontal, 10)
                        ChartView(selectedType: $selectedType, chartGroups: $chartGroups)
                                .padding(10)
                            
                            FilterTransactionsView(startDate: startDate, endDate: endDate) { transactions in
                                ForEach(transactions.filter { $0.transactionType == selectedType.rawValue }) { transaction in
                                    TransactionCardView(transaction: transaction)
                                    
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    } header: {
                        HeaderView(header: "Statistics", headerSize: 50, headerFontDesign: .serif) {
                            
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundStyle(.white)
                                    .background {
                                        Capsule()
                                            .rotationEffect(Angle(degrees: 180))
                                            .frame(width: 45, height: 60)
                                            .foregroundStyle(.accent)
                                    }
                            
                        }
                        .padding(10)
                    }
                }
                .overlay {
                    if chartGroups.isEmpty {
                        ContentUnavailableView("No Transactions Yet", systemImage: "xmark.seal")
                    }
                }
            }
            .onAppear {
                createChartView()
            }
    }
    }
}


#Preview(traits: .sampleTransactionData) {
    StatsScreen()
}




extension StatsScreen {
    
    
    
    nonisolated private func createChartGroup(from dict: Dictionary<GroupingKey, [Transaction]>.Element, type: TransactionType) -> ChartGroup? {
        let date = Calendar.current.date(from: dict.key.date) ?? .init()
        let category = dict.key.category
        let value = dict.value.filter { $0.transactionType == type.rawValue }
        let totalValue = total(value, type: type)
        
        return ChartGroup(date: date, category: category, totalValue: totalValue, type: type)
    }
    
    private func createChartView() {
        Task.detached(priority: .high) {
            
            let calendar = Calendar.current
            
            let groupedByDateAndCategory = await Dictionary(grouping: transactions) { transaction in
                let components = calendar.dateComponents([.day, .month, .year], from: transaction.date)
                return GroupingKey(date: components, category: transaction.category)
            }
            
            let sortedGroups = groupedByDateAndCategory.sorted {
                let date1 = calendar.date(from: $0.key.date) ?? .init()
                let date2 = calendar.date(from: $1.key.date) ?? .init()
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
               
            let chartGroups = sortedGroups.compactMap { createChartGroup(from: $0, type: .income) }
            
            await MainActor.run {
                self.chartGroups = chartGroups.sorted { $0.category < $1.category }
            }
            
        }
        
    }
    
}
