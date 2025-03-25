//
//  RecentsScreen.swift
//  Spendee
//
//  Created by Denis's MacBook on 20/3/25.
//

import SwiftUI

struct RecentsScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var selectedType: TransactionType = .expense
    @State private var isAddingTransactions: Bool = false
    @State private var isShowingFilterView: Bool = false
    
    @Namespace private var animation
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color.background
                
                ScrollView(.vertical) {
                    
                    LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
                        
                        Section {
                            
                            
                            
                            FilterTransactionsView(startDate: startDate, endDate: endDate) { transactions in
                                
                                //MARK: -  OverviewCardView
                                OverviewCardView(startDate: $startDate, endDate: $endDate, income: total(transactions, type: .income), expense: total(transactions, type: .expense))
                                
                                
                                //MARK: - Segmented Control
                                SegmentedControl()
                                
                                
                                //MARK: - Transaction Cards
                                ForEach(transactions.filter({ $0.transactionType == selectedType.rawValue })) { transaction in
                                    
                                    Menu {
                                        Button(role: .destructive) {
                                            modelContext.delete(transaction)
                                        } label: {
                                            HStack {
                                                Text("Delete")
                                                Image(systemName: "trash")
                                            }
                                        }
                                    } label: {
                                        TransactionCardView(transaction: transaction)
                                           
                                    } primaryAction: {
                                        print("Is tapped")
                                    
                                    }
                                    
                                }
                            }
                            
                            
                        } header: {
                            
                            HeaderView(header: "Spendee", headerSize: 50, headerFontWeight: .bold, headerFontDesign: .serif) {
                                Button {
                                    isShowingFilterView.toggle()
                                } label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundStyle(.white)
                                        .background {
                                            Capsule()
                                                .rotationEffect(Angle(degrees: 180))
                                                .frame(width: 45, height: 60)
                                                .foregroundStyle(.accent)
                                        }
                                }
                            }
                            
                            
                            
                            
                        }
                    }
                    .padding(15)
                }
               
                .blur(radius: isShowingFilterView ? 8 : 0)
                .sheet(isPresented: $isAddingTransactions) {
                    withAnimation(.easeInOut) {
                        AddTransactionView()
                    }
                }
                
                .overlay(alignment: .bottomTrailing) {
                    AddTransactionButton()
                }
                .overlay {
                    if isShowingFilterView {
                        DateFilterView(start: startDate, end: endDate) { start, end in
                            startDate = start
                            endDate = end
                            isShowingFilterView = false
                        } onCancel: {
                            isShowingFilterView = false
                        }
                        .transition(.move(edge: .leading))
                        
                    }
                    
                }
                .animation(.snappy, value: isShowingFilterView)
            }
            
        }
    }
}



//    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
//        let minY = proxy.frame(in: .scrollView).minY
//        let screenHeight = size.height
//
//        let progress = minY / screenHeight
//        let scale = (min(max(progress, 0), 1)) * 0.4
//
//        return 1 + scale
//    }



#Preview(traits: .sampleTransactionData) {
    RecentsScreen()
}


extension RecentsScreen {
    
    @ViewBuilder
    func SegmentedControl() -> some View {
        HStack {
            ForEach(TransactionType.allCases, id: \.rawValue) { type in
                Text(type.rawValue)
                    .foregroundStyle(.white)
                    .bold()
                
                    .font(.system(.subheadline, design: .serif))
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if selectedType == type {
                            Capsule()
                                .fill(
                                    LinearGradient(colors: [Color.theme.gradient1, Color.theme.gradient2, Color.theme.gradient3], startPoint: .trailing, endPoint: .leading)
                                )
                                .matchedGeometryEffect(id: "ACTIVATAB", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            selectedType = type
                        }
                        
                    }
                //                    .contentShape(.capsule)
                
            }
        }
        .background(Color.gray.opacity(0.5), in: .capsule)
        
    }
    
    @ViewBuilder
    func AddTransactionButton() -> some View {
        
        Button {
            isAddingTransactions.toggle()
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(.white)
                .padding(15)
                .bold()
                .background {
                    Capsule()
                        .foregroundStyle( LinearGradient(colors: [Color.theme.gradient1, Color.theme.gradient2, Color.theme.gradient3], startPoint: .trailing, endPoint: .leading)
                        )
                        .shadow(radius: 3)
                }
        }
        .padding()
    }
}
