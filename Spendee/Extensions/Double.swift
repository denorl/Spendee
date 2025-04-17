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
        
        let currencyCode = UserDefaults.standard.string(forKey: "currency") ?? "USD"
        
        
        if currencyCode == "USD" {
            let space = "\u{00a0}" // Non-breaking space
            formatter.locale = Locale(identifier: "en_US")
            formatter.positiveFormat = "¤\(space)#,##0.00"
            formatter.negativeFormat = "-¤\(space)#,##0.00"
        }
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter
    }
    
    func numberAsString() -> String {
        return numberFormatter.string(for: self) ?? ""
    }
    
    func asCurrencyString() -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
    
    func currencyString(for currency: String?) -> String {
        return self.formatted(.currency(code: currency ?? "USD"))
    }
    
}

