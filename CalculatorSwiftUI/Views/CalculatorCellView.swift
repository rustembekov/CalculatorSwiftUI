//
//  CalculatorCellView.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 05.07.2024.
//

import SwiftUI

struct CalculatorCellView: View {
    let index: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 50, height: 50)
            .foregroundColor(.blue)
            .overlay(
                Text("\(index + 1)")
                    .foregroundColor(.white)
            )
    }
}

struct CalculatorCellView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorCellView(index: 1)
    }
}
