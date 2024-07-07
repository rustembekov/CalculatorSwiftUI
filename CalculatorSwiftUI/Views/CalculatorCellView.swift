//
//  CalculatorCellView.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 05.07.2024.
//

import SwiftUI

struct CalculatorCellView: View {
    @ObservedObject var vm: CalculatorViewModel
    let button: String
    
    var body: some View {
        Button(action: {
            print("Button is typed: \(button)")
            self.vm.buttonTapped(button)
        }) {
            Text(button)
                .font(.custom("SF Pro Display", size: 32))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(button == "=" ? Color.yellow : Color.white)
                        .shadow(color: Color.theme.gray.opacity(0.5), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.theme.background.opacity(0.8), radius: 10, x: -5, y: -5)
                )
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
        }

    }
}

struct CalculatorCellView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.theme.textBackground
            CalculatorCellView(vm: CalculatorViewModel(), button: "=")
        }
    }
}
