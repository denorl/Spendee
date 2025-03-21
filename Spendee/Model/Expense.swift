//
//  Expense.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//

import Foundation
import SwiftData

@Model
class Transaction {
    var title: String
    var amount: Double
    var icon: String
    var date: Date
    var category: String
    var transactionType: String
    
   

    
    init(title: String, amount: Double, icon: String, date: Date, category: Category, transactionType: TransactionType) {
        self.title = title
        self.amount = amount
        self.icon = category.icon
        self.date = date
        self.category = category.rawValue
        self.transactionType = transactionType.rawValue
    }
    
    @Transient
    var rawTransactionType: TransactionType? {
        return TransactionType.allCases.first(where: { transactionType == $0.rawValue })
    }
    
    @Transient
    var rawCategory: Category? {
        return Category.allCases.first(where: { category == $0.rawValue })
    }
    
}



