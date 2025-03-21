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
            Transaction(title: "Compra nel Coop", amount: 348.96, icon: "cart", date: Date.now, category: .groceries, transactionType: .expense),
            Transaction(title: "Salary", amount: 1500, icon: "banknote.fill", date: Date.distantPast, category: .salary, transactionType: .income)
        ]
        
        //                   Insert the sample recipes into the context
        for transaction in transactions {
            context.insert(transaction)
        }
        
        // Save the context to persist the new data
        try? context.save()
    }
}
