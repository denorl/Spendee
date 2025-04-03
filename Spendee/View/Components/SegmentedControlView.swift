//
//  SegmentedControlView.swift
//  Spendee
//
//  Created by Denis's MacBook on 2/4/25.
//

import SwiftUI


struct SegmentedControlView: View {
    
    @Binding var selectedType: TransactionType
    
    @Namespace private var animation
    
    var body: some View {
        HStack {
            ForEach(TransactionType.allCases, id: \.rawValue) { type in
                Text(type.rawValue)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if selectedType == type {
                            Capsule()
                                .fill(
                                    LinearGradient(colors: [Color.theme.gradient1, Color.theme.gradient2, Color.theme.gradient3], startPoint: .trailing, endPoint: .leading)
                                )
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedType = type
                        }
                    }
                
            }
        }
        .background(Color.gray.opacity(0.5), in: .capsule)

    }
}
