//
//  CalculatorView.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 05.07.2024.
//

import SwiftUI

struct CalculatorView: View {
    

    @StateObject var vm = CalculatorViewModel()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        ZStack {
            Color.theme.backgroundCustom
                .ignoresSafeArea()
            VStack {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<16) { index in
                        CalculatorCellView(index: index)
                    }
                }
                .padding()
            }
            
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
