//
//  SettingsScreen.swift
//  Spendee
//
//  Created by Denis's MacBook on 20/3/25.
//

import SwiftUI

struct SettingsView: View {
    // Example states for toggles and selections
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.dismiss) private var dismiss
    
  
    @State private var selectedCurrency: String = "€"
    @State private var areNotificationsEnabled: Bool = true
    @State private var isUsingSystemSettingsEnabled: Bool = true
    
    @AppStorage("currency") var currency: String = "USD"
    
    
    // Example currency options
    
    let availableCurrencies: [String] = ["USD", "EUR", "CHF", "JPY", "GBP", "AUD", "CAD", "CNH", "HKD", "NZD"]
    
    func currencyName(currencyCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode]))
        return locale.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
    }

    var body: some View {
        NavigationStack {
           
                
                List {
                    Section(header: Text("General")) {
                        // Currency Selection
                        Picker("Currency", selection: $currency) {
                            ForEach(availableCurrencies, id: \.self) { currencyCode in
                                Text("\(currencyName(currencyCode: currencyCode)) (\(currencyCode))")
                            }
                            
                        }
                        
                        
                    }
                    
                    Section {
                        
                        Toggle("Dark Mode", isOn: Binding(
                            get: { themeManager.currentScheme == .dark },
                            set: { _ in themeManager.toggleDarkMode() }
                        ))
                        
                        Toggle("SystemSettings", isOn: Binding(
                            get: { themeManager.currentScheme == nil },
                            set: { _ in themeManager.toggleSystemMode() }
                        ))
                        
                    } header: {
                        Text("Appearance")
                    } footer: {
                        Text("System settings will override Dark Mode and use the current device theme")
                    }
                }
                .padding(.top)
                        
                
                
                
             
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("Settings")
                        .font(.system(size: 35, weight: .bold, design: .serif))
                        .padding(.top)
                }
            }
            
        }
        .preferredColorScheme(themeManager.currentScheme)
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
