//
//  UIApplication.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
