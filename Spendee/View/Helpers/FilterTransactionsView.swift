//
//  FilterTransactionsView.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//

import SwiftUI
import SwiftData

struct FilterTransactionsView<Content: View>: View {
    
    @Query(animation: .snappy) private var transactions: [Transaction]
    var content: ([Transaction]) -> Content
    
    
    init(startDate: Date, endDate: Date, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        let predicate = #Predicate<Transaction> { transaction in
            return transaction.date >= startDate && transaction.date <= endDate
        }
        
        _transactions = Query(filter: predicate, sort: [SortDescriptor(\Transaction.date, order: .reverse)])
        self.content = content
    }
    
    
    init(searchText: String, transactionType: TransactionType, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        let rawValue = transactionType.rawValue
        let predicate = #Predicate<Transaction> { transaction in
            return transaction.title.localizedStandardContains(searchText) && (rawValue.isEmpty ? true : transaction.transactionType == rawValue)
        }
        
        _transactions = Query(filter: predicate, sort: [SortDescriptor(\Transaction.date, order: .reverse)])
        self.content = content
    }
    
    var body: some View {
        content(transactions)
    }
}

