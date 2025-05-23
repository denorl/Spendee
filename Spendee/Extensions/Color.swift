//
//  Color.swift
//  Spendee
//
//  Created by Denis's MacBook on 20/3/25.
//

import SwiftUI


extension Color {
    
    static let theme = ColorTheme()
    
    struct ColorTheme {
        let backgoround = Color("BackgroundColor")
        let accent = Color("AccentColor")
//        let primary = Color("PrimaryTextColor")
        let secondary = Color("SecondaryTextColor")
        let elements = Color("ElementsBackgroundColor")
        
        let gradient1 = Color("BrightBlue")
        let gradient2 = Color("SoftPurple")
        let gradient3 = Color("CoralOrange")
    }
}
