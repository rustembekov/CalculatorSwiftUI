//
//  String.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 08.07.2024.
//

import Foundation

extension String {
    var asDouble: Double? {
        let cleanedText = self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
        
        return Double(cleanedText)
    }
}
