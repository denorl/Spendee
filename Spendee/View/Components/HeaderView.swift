//
//  HeaderView.swift
//  Spendee
//
//  Created by Denis's MacBook on 22/3/25.
//
import SwiftUI

struct HeaderView<Content: View>: View {
    var header: String
    
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
                    .padding(.bottom, 20)
            }
            .padding(.bottom, 5)
            .padding(.top)
            .padding(.horizontal, 15)
       
            .hSpacing(.leading)
            .background {
                
                Color.elementsBackground.shadow(color: .gray.opacity(0.5), radius: 3, x: 2)
                
                    .padding(.horizontal, -20)
                    .padding(.top, -(safeArea.top + 15))
                
            }
            .padding(.top, 35)
    }
    
}


extension HeaderView where Content == EmptyView {
    init(header: String, headerSize: CGFloat, headerFontDesign: Font.Design?) {
        self.init(header: header, headerSize: headerSize, headerFontDesign: headerFontDesign, topTrailingButton: { EmptyView() })
    }
}
