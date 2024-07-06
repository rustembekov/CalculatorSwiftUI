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
        VStack {
            ZStack {
                Color.theme.backgroundCustom
                    .ignoresSafeArea()
                TextField("", text: $vm.count)
                    .foregroundColor(.white)
                    .background {
                        Color.red
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
            VStack {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<20) { index in
                        CalculatorCellView(button: vm.buttons[index])
                    }
                }
                .padding()
            }
            
        }
    }
}
