//
//  RecentsScreen.swift
//  Spendee
//
//  Created by Denis's MacBook on 20/3/25.
//

import SwiftUI

struct RecentsScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var themeManager = ThemeManager()
    
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var selectedType: TransactionType = .income
   
    @State private var isAddingTransactions: Bool = false
    @State private var isEditingTransaction: Bool = false
    @State private var isShowingFilterView: Bool = false
    @State private var isShowingSettingsView: Bool = false
    
    
    @AppStorage("currency") var storedCurrency: String = "USD"
    @State private var currency: String = "USD"
    
    
    let availableCurrencies: [String] = ["USD", "EUR", "CHF", "JPY", "GBP", "AUD", "CAD", "CNH", "HKD", "NZD"]
    
//    @AppStorage("currency") var currency: String?
    
    @Namespace private var animation
    
    var body: some View {
        
        NavigationStack {
            FilterTransactionsView(startDate: startDate, endDate: endDate) { transactions in
                
               
                
            ZStack {
                Color.background
                    .ignoresSafeArea()
                    .sheet(isPresented: $isAddingTransactions) {
                        withAnimation(.easeInOut) {
                            AddTransactionView()
                        }
                    }
                   
                    .sheet(isPresented: $isEditingTransaction) {
                        withAnimation(.easeInOut) {
                            AddTransactionView(editTransaction: transactions.first(where: { $0.isSelected == true }))
                        }
                        
                    }
                    .sheet(isPresented: $isShowingSettingsView) {
                        SettingsView()
                            .presentationDetents([.medium])
                    }
                
                ScrollView(.vertical) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                     
                                
                                //MARK: -  OverviewCardView
                                OverviewCardView(startDate: $startDate, endDate: $endDate, income: total(transactions, type: .income), expense: total(transactions, type: .expense))
                                
                                
                                //MARK: - Segmented Control
                                SegmentedControlView(selectedType: $selectedType)
                                
                                
                                //MARK: - Transaction Cards
                                ForEach(transactions.filter({ $0.transactionType == selectedType.rawValue })) { transaction in
                                    
                                    TransactionCardView(transaction: transaction, actions: {
                                        DeleteButton(transaction: transaction)
                                          
                                 
                                        EditButton(transaction: transaction)
                                    })
                                    
                                }
                            }
                            
                            
                        
                    }
                    .padding(.horizontal, 10)
                }
                .blur(radius: isShowingFilterView ? 8 : 0)

                
                .overlay(alignment: .bottomLeading) {
                    SettingsButton()
                        .padding(.bottom)
                }
                
                .overlay(alignment: .bottomTrailing) {
                    AddTransactionButton()
                        .padding(.bottom)
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
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ToolbarHeader()
                }
            }
            .onAppear {
                print(currency)
                currency = storedCurrency
            }
            .onChange(of: storedCurrency) { _, _ in
                currency = storedCurrency
            }
        }
        .preferredColorScheme(themeManager.currentScheme)
    }
}



#Preview(traits: .sampleTransactionData) {
    RecentsScreen()
}


extension RecentsScreen {
    
    
    @ViewBuilder
    private func DeleteButton(transaction: Transaction) -> some View {
        Button(role: .destructive) {
            modelContext.delete(transaction)
        } label: {
            HStack {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
    
    @ViewBuilder
    private func EditButton(transaction: Transaction) -> some View {
        Button {
            transaction.isSelected = true


            isEditingTransaction.toggle()
        } label: {
            HStack {
                Text("Edit")
                Image(systemName: "pencil")
            }
        }
    }
    
    @ViewBuilder
    private func AddTransactionButton() -> some View {
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
    
    
    @ViewBuilder
    private func SettingsButton() -> some View {

        Button {
            isShowingSettingsView.toggle()
        } label: {
            Image(systemName: "gear")
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
    
    @ViewBuilder
    private func ToolbarHeader() -> some View {
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
