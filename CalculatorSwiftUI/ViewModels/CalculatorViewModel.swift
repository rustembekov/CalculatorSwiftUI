//
//  CalculatorViewModel.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 05.07.2024.
//

import SwiftUI
import Combine

enum Operation {
    case add, subtract, multiply, divide, none
}


class CalculatorViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var fontSize: CGFloat = 80
    
    @Published private var currentNumber = ""
    @Published private var previousNumber = ""
    @Published private var currentOperation: Operation?
    
    @Published var buttons: [String] = [
        "AC", "±", "%", "÷",
        "7", "8", "9", "×",
        "4", "5", "6", "-",
        "1", "2", "3", "+",
        "", "0", ".", "="
    ]
    
    private var cancellables = Set<AnyCancellable>()

    
    init() {
        Publishers.CombineLatest($currentNumber, $currentOperation)
            .sink { [weak self] currentNumber, currentOperation in
                self?.updateDisplay(currentNumber: currentNumber, currentOpearation: currentOperation)
            }
            .store(in: &cancellables)
    }
    
    func updateDisplay(currentNumber: String, currentOpearation: Operation?){
        if currentNumber.isEmpty {
            inputText = "0"
        } else {
            inputText = currentNumber
        }
        
    }
    
    func adjustFontSize(_ text: String) {
        let maxFontSize: CGFloat = 80
        let minFontSize: CGFloat = 50
        
        switch text.count {
        case 0...7:
            fontSize = maxFontSize
        case 8...12:
            fontSize = max(maxFontSize - CGFloat((text.count - 6) * 10), minFontSize)
        default:
            fontSize = maxFontSize
        }
    }
    
    func formatText(_ text: String) -> String {
        var formattedText = ""
        for (index, character) in text.enumerated() {
            if index != 0 && index % 3 == 0 {
                formattedText.append(" ")
            }
            formattedText.append(character)
        }
        return formatText(formattedText)
    }
    
    private func inputNumber(button: String) {
        if currentNumber.count < 9{
            currentNumber += button
        }
    }
    
    private func calculate(){
        guard let previous = Double(previousNumber),
              let current = Double(currentNumber),
              let operation = currentOperation
        else { return }
        
        var res: Double = 0.0
        switch operation {
        case .add:
            res = previous + current
        case .subtract:
            res = previous - current
        case .multiply:
            res = previous * current
        case .divide:
            res = previous / current
        case .none:
            return
        }
        
        inputText = String(res)
        currentNumber = inputText
        previousNumber = ""
        currentOperation = Operation.none
        
    }
    
    private func clear() {
        currentNumber = ""
        previousNumber = ""
        currentOperation = Operation.none
        inputText = "0"
    }
    
    func buttonTapped(button: String) {
        print("Button is: \(button)")

        switch button {
        case "0"..."9":
            inputNumber(button: button)
        case "+":
            currentOperation = .add
        case "-":
            currentOperation = .subtract
        case "*":
            currentOperation = .multiply
        case "/":
            currentOperation = .divide
        case "=":
            calculate()
        case "AC":
            clear()
        default:
            break
        }
    }
    
}

