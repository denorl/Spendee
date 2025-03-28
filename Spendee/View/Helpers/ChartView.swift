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
    
    @Query(animation: .snappy) private var transactions: [Transaction]
    
    @State private var rawSelectedDate: Date?
    @State private var incomeChartGroups: [ChartGroup] = []
    @State private var expenseChartGroups: [ChartGroup] = []
//    @State private var startDate: Date = .now.startOfMonth
//    @State private var endDate: Date = .now.endOfMonth
    
    var selectedGroup: ChartGroup? {
        guard let rawSelectedDate else { return nil }
        
        return incomeChartGroups.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: .day)
        }
    }
    
    var body: some View {
        VStack {
            Text("01 Jan 2021 - 31 Jan 2021")
                .font(.system(.title3, design: .serif))
                .foregroundStyle(.accent.opacity(0.5))
            Text("5000€")
                .font(.system(.largeTitle, design: .serif))
                .bold()
                .foregroundStyle(.accent)

            Chart {
                if let selectedGroup {
                    RuleMark(x: .value("Selected Month", selectedGroup.date, unit: .weekOfMonth))
                        .foregroundStyle(.secondary.opacity(0.5))
                        .annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart))) {
                            AnnotationCardView()
                        }
                    
                }
                ForEach(incomeChartGroups) { group in
                   
                    BarMark(
                        x: .value("Month", group.date, unit: .weekOfMonth),
                        y: .value(group.type.rawValue, group.totalValue),
                        width: 10
                    )
                    
                    .cornerRadius(5)
                    .position(by: .value("Category", group.category))
                    .foregroundStyle(by: .value("Category", group.category))
                    .opacity(rawSelectedDate == nil || group.date == selectedGroup?.date ? 1 : 0.3 )
                }
                
            }
            .onAppear(perform: {
                createChartView()
            })
           
            .frame(height: 200)
            .chartXScale(domain: Date.now.startOfMonth...Date.now.endOfMonth)
            .chartXAxis(.hidden)
            .chartForegroundStyleScale(foregrounds)
            //            .chartXScale(domain: startDate...endDate)
            
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            
            
            .chartLegend(spacing: 20) {
                HFlow {
                    ForEach(foregrounds, id: \.key) { kvp in
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
            
            
            .chartYAxis {
                
                AxisMarks(position: .leading) { value in
                    let doubleValue = value.as(Double.self) ?? 0
                    
                    
                    AxisGridLine()
                    AxisValueLabel {
                        Text(axisLabel(doubleValue))
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        }
    }
    
    let foregrounds: KeyValuePairs<String, AnyGradient> = [
        Category.salary.rawValue: Color.mint.gradient,
        Category.freelance.rawValue: Color.pink.gradient,
        Category.investments.rawValue: Color.purple.gradient,
        Category.gifts.rawValue: Color.red.gradient,
        Category.refunds.rawValue: Color.blue.gradient,
        Category.rentalIncome.rawValue: Color.green.gradient,
        Category.businessIncome.rawValue: Color.cyan.gradient,
        Category.passiveIncome.rawValue: Color.yellow.gradient
        
    ]
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Double(value)
        let kValue = intValue / 1000
        
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
    
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
            
            let incomeChartGroups = sortedGroups.compactMap { createChartGroup(from: $0, type: .income) }
            
            await MainActor.run {
                self.incomeChartGroups = incomeChartGroups
            }
            
        }
        
    }
}


#Preview(traits: .sampleTransactionData) {
    ChartView()
}


extension ChartView {
    nonisolated func createChartGroup(from dict: Dictionary<GroupingKey, [Transaction]>.Element, type: TransactionType) -> ChartGroup? {
        let date = Calendar.current.date(from: dict.key.date) ?? .init()
        let category = dict.key.category
        let value = dict.value.filter { $0.transactionType == type.rawValue }
        let totalValue = total(value, type: type)
        
        return ChartGroup(date: date, category: category, totalValue: totalValue, type: type)
    }
    
    @ViewBuilder
    func AnnotationCardView() -> some View {
        
        if let selectedGroup = selectedGroup {
            
            VStack {
                
                Text(selectedGroup.category)
                Text(selectedGroup.totalValue.asCurrencyString())
                
            }
            .foregroundStyle(.white)
            .padding()
            .background {
                
                if let categoryColor = foregrounds.first(where: { $0.key == selectedGroup.category }) {
                    
                    RoundedRectangle(cornerRadius: 20)
                    
                        .foregroundStyle(categoryColor.value)
                        .shadow(radius: 0.2)
                }
            }
        }
    }
    
    
    
}


//            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
//                let date = calendar.date(from: dict.key) ?? .init()
//                let income = dict.value.filter { $0.transactionType == TransactionType.income.rawValue }
//                let expense = dict.value.filter { $0.transactionType == TransactionType.expense.rawValue }
//                let incomeTotalValue = total(income, type: .income)
//                let expenseTotalValue = total(expense, type: .expense)
//
//                return .init(
//                    date: date,
//                    label: format(date: date, format: "MMM yy"),
//                    types: [
//                        .init(totalValue: incomeTotalValue, type: .income),
//                        .init(totalValue: expenseTotalValue, type: .expense)
//                    ])
//
//            }



//            Text("01 Jan 2021 - 31 Jan 2021")
//                .font(.system(.title3, design: .serif))
//                .foregroundStyle(.accent.opacity(0.5))
//            Text("5000€")
//                .font(.system(.largeTitle, design: .serif))
//                .bold()
//                .foregroundStyle(.accent)
