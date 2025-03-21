//
//  PreviewModifier.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//

import Foundation
import SwiftData
import SwiftUI


struct TransactionSampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Transaction.self, configurations: config)
        Transaction.makeSampleTransactions(in: container)
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleTransactionData: Self = .modifier(TransactionSampleData())
}
