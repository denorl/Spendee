//
//  ContentView.swift
//  Spendee
//
//  Created by Denis's MacBook on 16/3/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTab: Int = 0
    @Namespace var namespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                RecentsScreen()
                    .tag(0)
                SearchScreen()
                    .tag(1)
                StatsScreen()
                    .tag(2)
                SettingsScreen()
                    .tag(3)
            }
            .ignoresSafeArea()
        }
        
        ZStack {
            HStack {
                navBarItem(imageName: "house", tab: 0)
                Spacer()
                navBarItem(imageName: "magnifyingglass", tab: 1)
                Spacer()
                navBarItem(imageName: "chart.bar", tab: 2)
                Spacer()
                navBarItem(imageName: "gear", tab: 3)
                
                
            }
        }
        .padding(.horizontal)
        .padding(.top, 5)
        .background(
            Color.white.shadow(color: .gray.opacity(0.5), radius: 3, x: 2)
                .ignoresSafeArea()
        )
        
    }
}

#Preview(traits: .sampleTransactionData) {
    ContentView()
}

extension ContentView {
    func navBarItem(imageName: String, tab: Int) -> some View {
        Button {
            self.currentTab = tab
        } label: {
            
            VStack {
                Image(systemName: imageName)
                    .foregroundStyle(.black)
                    .padding(15)
                    .background {
                        if self.currentTab == tab {
                            Capsule().foregroundStyle(.accent).frame(width: 60, height: 40)
                                .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                        }
                    }
            }
            
        }
        .buttonStyle(.plain)
    }
}
