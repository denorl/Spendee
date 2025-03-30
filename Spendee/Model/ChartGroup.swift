//
//  Chart.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//
import SwiftUI

struct GroupingKey: Hashable {
    let date: DateComponents
    let category: String
}

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    let date: Date
    let category: String
    var totalValue: Double
    var type: TransactionType
    var isAnimated: Bool = false
    
}



