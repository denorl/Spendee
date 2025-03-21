//
//  SearchBarView.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var headerIsVisible: Bool
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty ? Color.black : Color.accent)
                .bold()
            
            TextField("Search any recipe...", text: $searchText,onEditingChanged: { status in
                if status == true {
                    withAnimation(.easeInOut) {
                        headerIsVisible = false
                    }
                    
                } else {
                    withAnimation(.easeInOut) {
                        headerIsVisible = true
                    }
                }
            })
                .foregroundStyle(Color.accent)
                .autocorrectionDisabled()
                .overlay (
                    Image(systemName: "x.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                           
                        }
                    
                    
                    
                    ,alignment: .trailing
                )
        }
        .contentShape(Rectangle())
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
                .shadow(color: Color.theme.accent.opacity(0.25), radius: 5)
            
        )
        
    }
}
