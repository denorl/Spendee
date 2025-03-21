//
//  SpendeeApp.swift
//  Spendee
//
//  Created by Denis's MacBook on 16/3/25.
//

import SwiftUI
import SwiftData

@main
struct SpendeeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Transaction.self])
    }
}
