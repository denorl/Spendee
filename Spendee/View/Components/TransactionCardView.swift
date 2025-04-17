//
//  TransactionCardView.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//

import SwiftUI

struct TransactionCardView<Actions:View>: View {
    
    @Environment(\.modelContext) private var context
    
    @AppStorage("currency") var currency: String?
    
    let actions: Actions
    
    let transaction: Transaction
    
    init(transaction: Transaction, @ViewBuilder actions: () -> Actions) {
        self.transaction = transaction
        self.actions = actions()
    }
    
    var body: some View {
        Menu {
            actions
        } label: {
            HStack(spacing: 14) {
                Image(systemName: transaction.icon)
                    .padding(.horizontal, 5)
                    .foregroundStyle(.white)
                    .background {
                        Capsule()
                            .rotationEffect(Angle(degrees: 180))
                            .frame(width: 40, height: 50)
                            .foregroundStyle(.accent)
                    }
               
                VStack(alignment: .leading) {
                    Text(transaction.title)
                        .font(.system(size: 20, design: .serif))
                        .bold()
                        .foregroundStyle(Color.primary)
                    Text(transaction.date.dateAsString())
                        .font(.subheadline)
                        .foregroundStyle(.secondaryText)
                }
                
                Spacer()
                Text(transaction.amount.asCurrencyString())
                    .font(.title3)
                    .foregroundStyle(transaction.transactionType == TransactionType.income.rawValue ? .green : .red)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.elementsBackground)
                    .shadow(radius: 0.5)
                    
                    
            }
      
        } primaryAction: {
            print("Transaction selected, ", transaction.title)
        }

       
  



    }
}


extension TransactionCardView where Actions == EmptyView {
    init(transaction: Transaction) {
        self.init(transaction: transaction, actions: { EmptyView() })
    }
}
