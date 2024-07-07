//
//  Double.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 07.07.2024.
//

import Foundation

extension Double {
    var customFormatted: String {
        let formattedString = String(format: "%.2f", self)
        if formattedString.hasSuffix(".00") {
            return String(format: "%.0f", self)
        } else if formattedString.hasSuffix("0") {
            return String(format: "%.1f", self)
        } else {
            return formattedString
        }
    }
}
