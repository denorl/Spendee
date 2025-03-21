//
//  View.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//
import SwiftUI


extension View {
    
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func total(_ transactions: [Transaction], type: TransactionType) -> Double {
        return transactions.filter({ $0.transactionType == type.rawValue}).reduce(Double.zero) { partialResult, transaction in
            partialResult + transaction.amount
        }
    }
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    
}
