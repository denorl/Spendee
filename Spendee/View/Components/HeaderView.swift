//
//  HeaderView.swift
//  Spendee
//
//  Created by Denis's MacBook on 22/3/25.
//
import SwiftUI

struct HeaderView<Content: View>: View {
    @State var header: String
    
    var headerSize: CGFloat
    var headerFontWeight: Font.Weight?
    var headerFontDesign: Font.Design?
    
    var topTrailingButton: () -> Content
   
    var body: some View {
        
        
        HStack(spacing: 10) {
            Text(header)
                .font(.system(size: headerSize, weight: headerFontWeight, design: headerFontDesign))
                .bold()
            
            Spacer()
            
            topTrailingButton()
        }
        .padding(.bottom, 30)
        .padding(.horizontal, 10)
        
        .hSpacing(.leading)
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .padding(.horizontal, -15)
            .padding(.top, -(safeArea.top + 15))
            
        }
    }
    
}
