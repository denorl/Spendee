//
//  ChartView.swift
//  Spendee
//
//  Created by Denis's MacBook on 25/3/25.
//

import SwiftUI
import Charts
import SwiftData
import Flow

struct ChartView: View {
    
    @AppStorage("currency") var currency: String?
    
    @Query(animation: .snappy) private var transactions: [Transaction]
   
    @State private var expenseChartGroups: [ChartGroup] = []
    @State private var incomeChartGroups: [ChartGroup] = []
    
    @State private var isLoading: Bool = true
    @State private var currentDate: Date = .now
    
    @Binding var selectedType: TransactionType
    @Binding var startDate: Date
    @Binding var endDate: Date 
    
   
   

    
    var body: some View {
        
        
        
          
        VStack {
            
           totalAmountView
            
            if !filteredChartGroups.isEmpty {
                
                Chart(filteredChartGroups) { group in
                    SectorMark(
                        angle: .value(group.category, group.totalValue),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    
                    .cornerRadius(10)
                    .foregroundStyle(by: .value(group.category, group.category))
                }
                .frame(height: 250)
                
                .chartForegroundStyleScale(foregrounds)
                .chartLegend(spacing: 20) {                    ChartLegendView()
                }
            } else if isLoading {
                ProgressView()
                    .frame(height: 250)
            } else {
                ContentUnavailableView("No transactions from this period", systemImage: "xmark.seal")
            }
            
        }
           
        .onAppear {
            createChartView()
        }
    }
    
    var foregrounds: KeyValuePairs<String, AnyGradient> = [
        Category.salary.rawValue: Color.mint.gradient,
        Category.freelance.rawValue: Color.pink.gradient,
        Category.investments.rawValue: Color.purple.gradient,
        Category.gifts.rawValue: Color.red.gradient,
        Category.refunds.rawValue: Color.blue.gradient,
        Category.rentalIncome.rawValue: Color.green.gradient,
        Category.businessIncome.rawValue: Color.cyan.gradient,
        Category.passiveIncome.rawValue: Color.yellow.gradient,
        
        Category.foodAndDrinks.rawValue: Color.orange.gradient,
        Category.groceries.rawValue: Color.green.gradient,
        Category.transportation.rawValue: Color.indigo.gradient,
        Category.housing.rawValue: Color.brown.gradient,
        Category.utilities.rawValue: Color.teal.gradient,
        Category.healthcare.rawValue: Color.red.gradient,
        Category.entertainment.rawValue: Color.pink.gradient,
        Category.shopping.rawValue: Color.purple.gradient,
        Category.subscriptions.rawValue: Color.cyan.gradient,
        Category.education.rawValue: Color.blue.gradient,
        Category.travel.rawValue: Color.mint.gradient,
        Category.giftsAndDonations.rawValue: Color.yellow.gradient,
        Category.insurance.rawValue: Color.gray.gradient,
        Category.personalCare.rawValue: Color.primary.gradient,
        Category.debtsAndLoans.rawValue: Color.secondary.gradient,
        Category.pets.rawValue: Color.orange.gradient,
        Category.savings.rawValue: Color.green.gradient
    ]
        
           
        
    let incomeForegrounds: KeyValuePairs<String, AnyGradient> = [
        Category.salary.rawValue: Color.mint.gradient,
        Category.freelance.rawValue: Color.pink.gradient,
        Category.investments.rawValue: Color.purple.gradient,
        Category.gifts.rawValue: Color.red.gradient,
        Category.refunds.rawValue: Color.blue.gradient,
        Category.rentalIncome.rawValue: Color.green.gradient,
        Category.businessIncome.rawValue: Color.cyan.gradient,
        Category.passiveIncome.rawValue: Color.yellow.gradient
    ]
    
    
    let expenseForegrounds: KeyValuePairs<String, AnyGradient> = [
        Category.foodAndDrinks.rawValue: Color.orange.gradient,
        Category.groceries.rawValue: Color.green.gradient,
        Category.transportation.rawValue: Color.indigo.gradient,
        Category.housing.rawValue: Color.brown.gradient,
        Category.utilities.rawValue: Color.teal.gradient,
        Category.healthcare.rawValue: Color.red.gradient,
        Category.entertainment.rawValue: Color.pink.gradient,
        Category.shopping.rawValue: Color.purple.gradient,
        Category.subscriptions.rawValue: Color.cyan.gradient,
        Category.education.rawValue: Color.blue.gradient,
        Category.travel.rawValue: Color.mint.gradient,
        Category.giftsAndDonations.rawValue: Color.yellow.gradient,
        Category.insurance.rawValue: Color.gray.gradient,
        Category.personalCare.rawValue: Color.primary.gradient,
        Category.debtsAndLoans.rawValue: Color.secondary.gradient,
        Category.pets.rawValue: Color.orange.gradient,
        Category.savings.rawValue: Color.green.gradient
  ]
    

    
    func createChartView() {
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
            let incomeChartGroups = sortedGroups.compactMap { createChartGroup(from: $0, type: .income)}
            let expenseChartGroups = sortedGroups.compactMap { createChartGroup(from: $0, type: .expense)}
            
            await MainActor.run {
                self.incomeChartGroups =  incomeChartGroups.sorted { $0.category < $1.category }
                self.expenseChartGroups =  expenseChartGroups.sorted { $0.category < $1.category }
                self.isLoading = false
            }
            
        }
        
    }
    
    
}



extension ChartView {
    
    private var totalAmountView: some View {
        Text(totalAmount.asCurrencyString())
            .font(.system(.largeTitle, design: .serif))
            .bold()
            .foregroundStyle(.accent)
    }
    
    private func changeCurrentMonth(by value: Int) {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = date
            startDate = currentDate.startOfMonth
            endDate = currentDate.endOfMonth
        }
    }

    private var filteredChartGroups: [ChartGroup] {
        if selectedType == .income {
            return incomeChartGroups.filter { $0.date >= startDate && $0.date <= endDate && $0.type == selectedType }
        } else {
            return expenseChartGroups.filter { $0.date >= startDate && $0.date <= endDate && $0.type == selectedType }
        }
    }
    
    private var totalAmount: Double {
       
        return filteredChartGroups.reduce(0) { $0 + $1.totalValue }
        
    }
    
    nonisolated func createChartGroup(from dict: Dictionary<GroupingKey, [Transaction]>.Element, type: TransactionType) -> ChartGroup? {
        
        let date = Calendar.current.date(from: dict.key.date) ?? .init()
        let category = dict.key.category
        let value = dict.value
        let totalValue = total(value, type: type)
        
        return ChartGroup(date: date, category: category, totalValue: totalValue, type: type)
        
    }
    
    @ViewBuilder
    private func ChartLegendView() -> some View {
        HFlow {
            ForEach(selectedType == .income ? incomeForegrounds : expenseForegrounds, id: \.key) { kvp in
                Label {
                    Text(kvp.key)
                        .font(.caption)
                } icon: {
                    Image(systemName: "circle.fill")
                        .font(.caption)
                        .foregroundStyle(kvp.value)
                }
            }
        }
    }
}
