//
//  AddTransactionView.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    
    
    
    @State private var title: String = ""
    @State private var amount: Double = .zero
    @State private var icon: String = ""
    @State private var date: Date = .init()
    @State private var category: Category = .other
    @State private var transactionType: TransactionType = .expense
    
    var isValid: Bool {
       return !title.isEmpty && amount != .zero
    }
    var editTransaction: Transaction?
    
    var body: some View {
        NavigationStack {
            
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    
                    //MARK: - Preview Section
                    VStack(alignment: .leading) {
                        Text("Preview")
                            .font(.headline)
                            .hSpacing(.leading)
                        TransactionCardView(transaction: .init(title: title.isEmpty ? "Title" : title, amount: amount, icon: icon.isEmpty ? "questionmark.circle.fill" : icon, date: date, category: category, transactionType: transactionType))
                    }
                    
                    
                    //MARK: - Title Section
                    CustomSection("Title", "Type the name", text: $title)
                    
                    //MARK: - Amount Section
                    VStack(alignment: .leading) {
                        Text("Amount")
                            .font(.headline)
                            .hSpacing(.leading)
                        HStack {
                            HStack {
                                Text(currencySymbol)
                                TextField("0.00", value: $amount, formatter: numberFormatter)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .frame(maxWidth: 130)
                            .background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 10))
                            TypeCheckBox()
                        }
                    }
                    
                    //MARK: - Category Section
                    
                    VStack(alignment: .leading) {
                        Text("Category")
                            .font(.headline)
                            .hSpacing(.leading)
                        
                        Picker("Category", selection: $category) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.rawValue)
                                  
                            }
                        }
                        .pickerStyle(.wheel)
//                        .padding(.horizontal, 15)
//                        .padding(.vertical, 12)
//
//                        .background(Color.gray.opacity(0.2), in: .rect(cornerRadius: 10))
                        
                    }
                    
                    //MARK: - Date Section
                    
                    VStack(alignment: .leading) {
                        Text("Date")
                            .font(.headline)
                            .hSpacing(.leading)
                        DatePicker("date", selection: $date, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .tint(.accent)
                            .background(Color.gray.opacity(0.05), in: .rect(cornerRadius: 10))
                    }
                    
                    //MARK: - Save Button
                    VStack {
                        Button {
                            //Save
                            saveTransaction()
                            dismiss()
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 50)
                                .foregroundStyle(.accent)
                                .overlay {
                                    Text("Save")
                                        .font(.system(.title, design: .serif))
                                        .bold()
                                        .foregroundStyle(.white)
                                }
                            
                        }
                    }
                    

                    
                    
                }
                .padding(15)
                Spacer()
            }
            .navigationTitle(editTransaction == nil ? "Add New Transaction" : "Edit Transaction")
            .onAppear {
                if let editTransaction {
                    title = editTransaction.title
                    icon = editTransaction.icon
                    amount = editTransaction.amount
                    date = editTransaction.date
                    if let category = editTransaction.rawCategory {
                        self.category = category
                    }
                    if let type = editTransaction.rawTransactionType {
                        transactionType = type
                    }
                }
            }
        }
    }
    
    
    func saveTransaction() {
        guard isValid else { return }
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.amount = amount
            editTransaction?.icon = icon
            editTransaction?.date = date
            editTransaction?.category = category.rawValue
            editTransaction?.transactionType = transactionType.rawValue
            modelContext
        } else {
            let newTransaction = Transaction(title: title, amount: amount, icon: icon, date: date, category: category, transactionType: transactionType)
            modelContext.insert(newTransaction)
        }
    }
    
}

#Preview {
    AddTransactionView()
}



extension AddTransactionView {
    @ViewBuilder
    func CustomSection(_ title: String, _ titleKey: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                
            
            TextField(titleKey, text: text)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 10))
        }
        .hSpacing()
       
    }
    
    @ViewBuilder
    func TypeCheckBox() -> some View {
        HStack(spacing: 10) {
            ForEach(TransactionType.allCases, id: \.rawValue) { type in
               
                    HStack {
                        ZStack {
                            Image(systemName: "circle")
                                .font(.title3)
                                .foregroundStyle(.gray.opacity(0.5))
                            
                            if transactionType == type {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.accent)
                            }
                        }
                        Text(type.rawValue)
                        
                    }
                    .contentShape(.rect(cornerRadius: 10))
                    .onTapGesture {
                        transactionType = type
                    }
                
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 10))
    }
    
    
    
}
