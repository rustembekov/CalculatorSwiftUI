//
//  Operation.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 07.07.2024.
//

import Foundation
import SwiftUI

enum Operation {
     case add, subtract, multiply, divide, none
     
     var symbol: String {
         switch self {
         case .add:
             return "+"
         case .subtract:
             return "-"
         case .multiply:
             return "×"
         case .divide:
             return "÷"
         case .none:
             return ""
         }
     }
 }
