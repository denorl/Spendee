//
//  Date.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//


import SwiftUI

extension Date {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    func dateAsString() -> String {
        return dateFormatter.string(for: self) ?? ""
    }
    
    
    
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return calendar.date(from: components) ?? self
    }
    
    var endOfMonth: Date {
        let calendar = Calendar.current
        
        return calendar.date(byAdding: .init(month: 1, minute: -1), to: self.startOfMonth) ?? self
    }
    
}
