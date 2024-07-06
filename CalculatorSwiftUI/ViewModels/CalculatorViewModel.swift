//
//  CalculatorViewModel.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 05.07.2024.
//

import SwiftUI

class CalculatorViewModel: ObservableObject {
    @Published var count: String = ""
    @Published var buttons: [String] = [
        "AC", "±", "%", "÷",
        "7", "8", "9", "×",
        "4", "5", "6", "-",
        "1", "2", "3", "+",
        "", "0", ".", "="
    ]
    
    
}

