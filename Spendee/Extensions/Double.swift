//
//  Double.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//
import SwiftUI


extension Double {
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }
    
    func numberAsString() -> String {
        return numberFormatter.string(for: self) ?? ""
    }
    
    func asCurrencyString() -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
    
}

