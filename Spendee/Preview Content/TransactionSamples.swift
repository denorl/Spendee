//
//  TransactionSamples.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//


import SwiftData
import SwiftUI

extension Transaction {
    @MainActor static func makeSampleTransactions(in container: ModelContainer) {
        let context = container.mainContext
        
        // Check if there are any existing recipes in the database
        let existingRecipesCount = (try? context.fetch(FetchDescriptor<Transaction>()))?.count ?? 0
        guard existingRecipesCount == 0 else {
            // If there are existing recipes, do not create new ones
            return
        }
        
        //                   Sample data to create
        let transactions = [
//            Transaction(title: "Coop", amount: 348.96, icon: "cart", date: Date.now, category: .groceries, transactionType: .expense),
          
//            Transaction(title: "Weekly Groceries", amount: 60.75, icon: "cart.fill", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, category: .groceries, transactionType: .expense),
            Transaction(title: "Monthly Salary", amount: 2800.00, icon: "creditcard.fill", date: Calendar.current.date(byAdding: .day, value: -50, to: Date())!, category: .salary, transactionType: .income),
            Transaction(title: "Bus Ticket", amount: 2.50, icon: "bus.fill", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, category: .transportation, transactionType: .expense),
//            Transaction(title: "Netflix Subscription", amount: 13.99, icon: "tv.fill", date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, category: .subscriptions, transactionType: .expense),
            Transaction(title: "Freelance Project", amount: 950.00,  icon: "laptopcomputer", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, category: .freelance, transactionType: .income),
//            Transaction(title: "Dinner Out", amount: 42.30, icon: "fork.knife.circle.fill", date: Calendar.current.date(byAdding: .day, value: -40, to: Date())!, category: .foodAndDrinks, transactionType: .expense),
            Transaction(title: "Stock Dividends", amount: 150.00, icon: "chart.line.uptrend.xyaxis", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, category: .investments, transactionType: .income),
            Transaction(title: "Stock Dividends", amount: 1500.00, icon: "chart.line.uptrend.xyaxis", date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, category: .businessIncome, transactionType: .income),
            Transaction(title: "Travel to Rome", amount: 200.00, icon: "airplane", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, category: .travel, transactionType: .expense),
//            Transaction(title: "Gift from Family", amount: 100.00, icon: "gift.fill", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, category: .gifts, transactionType: .income),
//            Transaction(title: "Shampoo & Soap", amount: 18.00, icon: "drop.fill", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, category: .personalCare, transactionType: .expense)
//           
        ]
        
        //                   Insert the sample recipes into the context
        for transaction in transactions {
            context.insert(transaction)
        }
        
        // Save the context to persist the new data
        try? context.save()
    }
}
