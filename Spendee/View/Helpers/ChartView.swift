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
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    
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

            Chart(incomeChartGroups.filter({ $0.date >= startDate && $0.date <= endDate })) { group in
                SectorMark(
                    angle: .value(group.category, group.totalValue),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .cornerRadius(10)
                .foregroundStyle(by: .value(group.category, group.category))
            }
            .onAppear(perform: {
                createChartView()
            })
           
            .frame(height: 250)
            

            .chartForegroundStyleScale(foregrounds)
            
//            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
//            
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
    
//    func axisLabel(_ value: Double) -> String {
//        let intValue = Double(value)
//        let kValue = intValue / 1000
//        
//        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
//    }
    
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
    
//    private func animateChart() {
//        guard !isAnimated else { return }
//        isAnimated = true
//        
//        $chartGroups.enumerated().forEach { index, element in
//            let delay = Double(index) * 0.05
//            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                element.wrappedValue.isAnimated = true
//            }
//        }
//    }
    
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
