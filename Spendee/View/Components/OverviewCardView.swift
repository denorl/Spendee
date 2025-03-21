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
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(
                    LinearGradient(colors: [Color.theme.gradient1, Color.theme.gradient2, Color.theme.gradient3], startPoint: .trailing, endPoint: .leading)
                    )
               
                .frame(height: 200)
                
                
            VStack {
                Text("\(format(date: startDate, format: "dd MMM yyyy")) - \(format(date: endDate, format: "dd MMM yyyy"))")
//                    .foregroundStyle(.white)
                    .font(.system(.title3, design: .serif))
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.top)
                
                Spacer()
                Text((income - expense).asCurrencyString())
                    .font(.system(.largeTitle, design: .serif))
                    .bold()
                    .foregroundStyle(.white)
                Spacer()
                 
                HStack {
                    ForEach(TransactionType.allCases, id: \.rawValue) { type in
                        HStack {
                            Image(systemName: type == .income ? "arrowshape.up.circle.fill" : "arrowshape.down.circle.fill" )
                                .foregroundStyle(type == .income ? .green : .red)
                                .font(.title)
                            VStack(alignment: .leading) {
                                Text(type.rawValue)
                                    .font(.system(.subheadline, design: .serif))
                                Text(type == .income ? income.asCurrencyString() : expense.asCurrencyString())
                            }
                            .font(.system(.headline, design: .serif))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            
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
