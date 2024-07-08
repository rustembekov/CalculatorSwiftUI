//
//  Double.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 07.07.2024.
//

import Foundation

extension Double {
    var customFormatted: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        
        // Check if the number is an integer or not
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            formatter.minimumFractionDigits = 0
        }
        
        let formattedString = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        
        if let range = formattedString.range(of: ".") {
            let integerPart = String(formattedString[..<range.lowerBound])
            let decimalPart = String(formattedString[range.lowerBound...])
            
            let integerFormatted = formatter.string(from: NSNumber(value: Double(integerPart.replacingOccurrences(of: " ", with: "")) ?? 0)) ?? integerPart
            return "\(integerFormatted)\(decimalPart)"
        }
        
        return formattedString
    }
}
