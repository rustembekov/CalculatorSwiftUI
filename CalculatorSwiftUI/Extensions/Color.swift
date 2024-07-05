//
//  Color.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 05.07.2024.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("Background")
    let backgroundCustom = Color("BackgroundCustomColor")
    let textAccent = Color("TextColor")
    let textBackground = Color("TextBackgroundColor")
    let gray = Color("TextGray")
}
