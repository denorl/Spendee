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
            
            ScrollView(.vertical) {
                
                LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        
                        Text("Transactions Overview")
                            .font(.system(size: 25, design: .serif))
                            .bold()
                        
                        FilterTransactionsView(startDate: startDate, endDate: endDate) { transactions in
                            
                            //MARK: -  OverviewCardView
                            OverviewCardView(startDate: $startDate, endDate: $endDate, income: total(transactions, type: .income), expense: total(transactions, type: .expense))
                            
                            
                            //MARK: - Segmented Control
                            SegmentedControl()
                            
                            
                            //MARK: - Transaction Cards
                            ForEach(transactions.filter({ $0.transactionType == selectedType.rawValue })) { transaction in
                                NavigationLink {
                                    AddTransactionView(editTransaction: transaction)
                                } label: {
                                    TransactionCardView(transaction: transaction)
                                }
                            }
                        }
                        
                        
                    } header: {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 10) {
                                Text("Spendee")
                                    .font(.system(size: 30, design: .serif))
                                    .bold()
                                    
                                Spacer()
                                
                                Button {
                                    isShowingFilterView.toggle()
                                } label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundStyle(.white)
                                        .background {
                                            Capsule()
                                                .rotationEffect(Angle(degrees: 180))
                                                .frame(width: 40, height: 55)
                                                .foregroundStyle(.accent)
                                        }
                                }

                            }
                            .padding(.bottom)
                            .padding(.horizontal, 10)
                        }
                        .hSpacing(.leading)
                        .background {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                Divider()
                            }
                            .padding(.horizontal, -15)
                            .padding(.top, -(safeArea.top + 15))

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
                    .font(.system(.subheadline, design: .serif))
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if selectedType == type {
                            Capsule()
                                .fill(Color.accent.opacity(0.2))
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
        .background(Color.gray.opacity(0.2), in: .capsule)
        
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
                        .foregroundStyle(.accent)
                }
        }
        .padding()
    }
}
