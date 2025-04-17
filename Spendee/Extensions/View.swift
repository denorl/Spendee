//
//  View.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//
import SwiftUI


extension View {
    
    nonisolated func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    nonisolated func total(_ transactions: [Transaction], type: TransactionType?) -> Double {
        let rawValue = type?.rawValue ?? ""
        return transactions.filter({ $0.transactionType == rawValue}).reduce(Double.zero) { partialResult, transaction in
            partialResult + transaction.amount
        }
    }
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    var currencySymbol: String {
        let locale = Locale.current
        return locale.currencySymbol ?? ""
    }
    
    
    
    @available(iOSApplicationExtension, unavailable)
    var safeArea: UIEdgeInsets {
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        
        return .zero
    }
    
}
