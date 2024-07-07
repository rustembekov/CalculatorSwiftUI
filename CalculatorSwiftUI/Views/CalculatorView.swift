//
//  CalculatorView.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 05.07.2024.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var vm = CalculatorViewModel()
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        VStack {
            ZStack {
                Color.theme.backgroundCustom
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text(vm.inputText)
                        .font(.custom("SF Pro Display", size: vm.fontSize))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(height: 90)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                        
                }
            }
            sectionOperations
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 475)
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}

extension CalculatorView {
    private var sectionOperations: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<vm.buttons.count, id: \.self) { index in
                        if(vm.buttons[index].isEmpty) {
                            Color.clear
                        } else {
                            CalculatorCellView(vm: vm, button: vm.buttons[index])
                        }
                    }
                }
                .padding()
            }
        }
    }
}
