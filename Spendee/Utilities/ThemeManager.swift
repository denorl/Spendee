//
//  ThemeManager.swift
//  Spendee
//
//  Created by Denis's MacBook on 15/4/25.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isSystemMode") private var isSystemMode: Bool = true
    
        
        var currentScheme: ColorScheme? {
            if isSystemMode {
                return nil
            } else if isDarkMode {
                return .dark
            } else {
                return .light
            }
        }
        
        func toggleDarkMode() {
            isDarkMode.toggle()
        }
    
    func toggleSystemMode() {
        isSystemMode.toggle()
    }
}
