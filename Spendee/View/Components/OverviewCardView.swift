//
//  OverviewCardView.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//

import SwiftUI

struct OverviewCardView: View {
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var income: Double
    var expense: Double
   
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 150)
                
                
            VStack {
                Text("\(format(date: startDate, format: "dd MMM yyyy")) - \(format(date: endDate, format: "dd MMM yyyy"))")
//                    .foregroundStyle(.white)
                    .font(.system(.title3, design: .serif))
                    .bold()
                    .padding(.top)
                
                Text((income - expense).asCurrencyString())
                    .font(.system(.title2, design: .serif))
                    .bold()
                    .foregroundStyle(income > expense ? .green : .red)
                
                 
                HStack {
                    ForEach(TransactionType.allCases, id: \.rawValue) { type in
                        HStack {
                            Image(systemName: type == .income ? "arrowshape.up.circle.fill" : "arrowshape.down.circle.fill" )
                                .foregroundStyle(type == .income ? .green : .red)
                                .font(.title)
                            VStack(alignment: .leading) {
                                Text(type.rawValue)
                                    .foregroundStyle(.secondary)
                                Text(type == .income ? income.asCurrencyString() : expense.asCurrencyString())
                            }
                            .font(.system(.subheadline, design: .serif))
                            .fontWeight(.semibold)
                            
                            if type == .income {
                                Spacer(minLength: 10)
                            }
                        }
                        
                        .padding(.horizontal)
                    }
                }
                
                
                Spacer()
                
            }
        }
    }
}
