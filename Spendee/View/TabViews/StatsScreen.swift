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
    
    @Query(filter: #Predicate<Transaction> { $0.transactionType == "Income" }, animation: .snappy) private var incomes: [Transaction]
    
    @Query(filter: #Predicate<Transaction> { $0.transactionType == "Expense" }, animation: .snappy) private var expenses: [Transaction]
    
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    
    @State private var chartGroups: [ChartGroup] = []
    @State private var incomeChartGroups: [ChartGroup] = []
    @State private var expenseChartGroups: [ChartGroup] = []
    @State private var selectedType: TransactionType = .income
    
    @State private var rawSelectedDate: Date?
    

    
    var selectedGroup: ChartGroup? {
        guard let rawSelectedDate else { return nil }
        
        return incomeChartGroups.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: .month)
        }
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    
                    ChartView()
                        .padding(10)
                }
            }
            .onAppear {
               
                print(incomeChartGroups.count)
            }
    }
    }
}


#Preview(traits: .sampleTransactionData) {
    StatsScreen()
}


extension StatsScreen {

       
    
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Double(value)
        let kValue = intValue / 1000
        
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
    
//    func createChartView() {
//        Task.detached(priority: .high) {
//            let calendar = Calendar.current
//            
//            
//            let groupedByDateAndCategory = await Dictionary(grouping: transactions) { transaction in
//                let components = calendar.dateComponents([.month, .year], from: transaction.date)
//                
//                return GroupingKey(date: components, category: transaction.category)
//            }
//            
//            
//            let sortedGroups = groupedByDateAndCategory.sorted {
//                let date1 = calendar.date(from: $0.key.date) ?? .init()
//                let date2 = calendar.date(from: $1.key.date) ?? .init()
//                
//                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
//            }
//            
//            let incomeChartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
//                let date = calendar.date(from: dict.key.date) ?? .init()
//                let category = dict.key.category
//                let income = dict.value.filter { $0.transactionType == TransactionType.income.rawValue }
//                let incomeTotalValue = total(income, type: .income)
//                
//                return .init(date: date, category: category, totalValue: incomeTotalValue, type: .income)
//            }
//            
////            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
////                let date = calendar.date(from: dict.key) ?? .init()
////                let income = dict.value.filter { $0.transactionType == TransactionType.income.rawValue }
////                let expense = dict.value.filter { $0.transactionType == TransactionType.expense.rawValue }
////                let incomeTotalValue = total(income, type: .income)
////                let expenseTotalValue = total(expense, type: .expense)
////                
////                return .init(
////                    date: date,
////                    label: format(date: date, format: "MMM yy"),
////                    types: [
////                        .init(totalValue: incomeTotalValue, type: .income),
////                        .init(totalValue: expenseTotalValue, type: .expense)
////                    ])
////                
////            }
//            
//            
//            
//            await MainActor.run {
//                self.incomeChartGroups = incomeChartGroups
//                
////                self.chartGroups = chartGroups
//            }
//            
//        }
//        
//    }
    
    @ViewBuilder
    func BarMarkView() -> some View {
        
    }
    
}
