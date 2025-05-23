//
//  Category.swift
//  Spendee
//
//  Created by Denis's MacBook on 21/3/25.
//
import Foundation
import SwiftUI

enum Category: String, CaseIterable {
    
    
    case foodAndDrinks = "Food & Drinks"
    case groceries = "Groceries"
    case transportation = "Transportation"
    case housing = "Housing"
    case utilities = "Utilities"
    case healthcare = "Healthcare"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case subscriptions = "Subscriptions"
    case education = "Education"
    case travel = "Travel"
    case giftsAndDonations = "Gifts & Donations"
    case insurance = "Insurance"
    case personalCare = "Personal Care"
    case debtsAndLoans = "Debts & Loans"
    case pets = "Pets"
    case savings = "Savings"
    
    case salary = "Salary"
    case freelance = "Freelance"
    case investments = "Investments"
    case gifts = "Gifts"
    case refunds = "Refunds"
    case rentalIncome = "Rental Income"
    case businessIncome = "Business Income"
    case passiveIncome = "Passive Income"
    case other = "Other"
}



extension Category {
    var icon: String {
        switch self {
        case .foodAndDrinks: return "fork.knife"
        case .groceries: return "cart"
        case .transportation: return "car.fill"
        case .housing: return "house.fill"
        case .utilities: return "bolt.fill"
        case .healthcare: return "cross.case.fill"
        case .entertainment: return "gamecontroller.fill"
        case .shopping: return "bag.fill"
        case .subscriptions: return "creditcard.fill"
        case .education: return "book.fill"
        case .travel: return "airplane"
        case .giftsAndDonations: return "gift.fill"
        case .insurance: return "shield.fill"
        case .personalCare: return "scissors"
        case .debtsAndLoans: return "dollarsign.circle.fill"
        case .pets: return "pawprint.fill"
        case .savings: return "banknote.fill"
            
        case .salary: return "banknote.fill"
        case .freelance: return "laptopcomputer"
        case .investments: return "chart.line.uptrend.xyaxis"
        case .refunds: return "arrow.uturn.left.circle.fill"
        case .rentalIncome: return "house.fill"
        case .businessIncome: return "briefcase.fill"
        case .passiveIncome: return "clock.arrow.circlepath"
        case .gifts: return "gift.fill"
            
        case .other: return "questionmark.circle.fill"
        }
    }
    
    var gradient: AnyGradient {
        switch self {
        case .foodAndDrinks:
            Color.mint.gradient
        case .groceries:
            Color.pink.gradient
        case .transportation:
            Color.purple.gradient
        case .housing:
            Color.red.gradient
        case .utilities:
            Color.blue.gradient
        case .healthcare:
            Color.green.gradient
        case .entertainment:
            Color.cyan.gradient
        case .shopping:
            Color.yellow.gradient
        case .subscriptions:
            Color.orange.gradient
        case .education:
            Color.green.gradient
        case .travel:
            Color.indigo.gradient
        case .giftsAndDonations:
            Color.brown.gradient
        case .insurance:
            Color.teal.gradient
        case .personalCare:
            Color.red.gradient
        case .debtsAndLoans:
            Color.pink.gradient
        case .pets:
            Color.purple.gradient
        case .savings:
            Color.cyan.gradient
        case .salary:
            Color.blue.gradient
        case .freelance:
            Color.mint.gradient
        case .investments:
            Color.yellow.gradient
        case .gifts:
            Color.gray.gradient
        case .refunds:
            Color.primary.gradient
        case .rentalIncome:
            Color.secondary.gradient
        case .businessIncome:
            Color.orange.gradient
        case .passiveIncome:
            Color.green.gradient
        case .other:
            Color.gray.gradient
        }
    }
    

}
