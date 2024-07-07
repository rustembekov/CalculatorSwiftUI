//
//  CalculatorViewModel.swift
//  CalculatorSwiftUI
//
//  Created by Sabr on 05.07.2024.
//

import SwiftUI
import Combine

class CalculatorViewModel: ObservableObject {
    @Published var inputText = "0"
    @Published var fontSize: CGFloat = 80
    
    @Published private var currentNumber = ""
    @Published private var previousNumber = ""
    @Published private var currentOperation: Operation? = Operation.none
    
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
                self?.updateDisplay(currentNumber: currentNumber, currentOperation: currentOperation)
            }
            .store(in: &cancellables)
    }
    
    func updateDisplay(currentNumber: String, currentOperation: Operation?){
        if currentNumber.isEmpty {
            print("current number is empty")
            inputText = "0"
        } else {
            inputText = currentNumber
            print("current number is not empty \(currentNumber), inputText: \(inputText)")
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
        return formattedText
    }
    
    private func inputNumber(_ number: String) {
        if currentNumber.count < 9 {
            currentNumber += number
            print("Current number updated to: \(currentNumber)")
        }
    }
    
    private func inputOperation(_ operation: Operation) {
        if !currentNumber.isEmpty {
            previousNumber = currentNumber
            currentNumber = ""
            currentOperation = operation
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
        
        inputText = res.customFormatted
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
    
    func buttonTapped(_ button: String) {
        
        switch button {
        case "0"..."9", ".":
            inputNumber(button)
        case "+":
            inputOperation(.add)
        case "-":
            inputOperation(.subtract)
        case "×":
            inputOperation(.multiply)
        case "÷":
            inputOperation(.divide)
        case "=":
            calculate()
        case "AC":
            clear()
        default:
            break
        }
    }
}
