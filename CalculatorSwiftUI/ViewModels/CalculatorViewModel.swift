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
    private var lastOperation: Operation? = nil
    private var lastOperand: String = ""
    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest($currentNumber, $currentOperation)
            .sink { [weak self] currentNumber, currentOperation in
                self?.updateDisplay(currentNumber: currentNumber, currentOperation: currentOperation)
            }
            .store(in: &cancellables)
    }
    
    func updateDisplay(currentNumber: String, currentOperation: Operation?){
        if currentNumber.isEmpty  {
            print("current number is empty")
            inputText = "0"
        } else if currentNumber == "Error" {
            inputText = "Error"
        } else {
            inputText = setupText(text: currentNumber)
            print("current number is not empty \(currentNumber), inputText: \(inputText)")
        }
    }
    
    private func adjustFontSize(_ text: String) {
        let maxFontSize: CGFloat = 80
        let minFontSize: CGFloat = 50
        
        switch text.count {
        case 0...6:
            fontSize = maxFontSize
        case 7...12:
            fontSize = max(maxFontSize - CGFloat((text.count - 5) * 10), minFontSize)
        default:
            fontSize = maxFontSize
        }
    }

    private func setupText(text: String) -> String {
        let formattedText = formatText(text)
        adjustFontSize(formattedText)
        return formattedText
    }


    private func inputNumber(_ number: String) {
        if currentNumber == "0" {
            currentNumber = number
        } else if currentNumber.count < 9 {
            currentNumber += number
        }
        print("Current number updated to: \(currentNumber)")
    }
    
    private func inputOperation(_ operation: Operation) {
        if !currentNumber.isEmpty {
            previousNumber = currentNumber
            currentNumber = ""
            currentOperation = operation
        }
    }
    
    private func calculate() {
        guard let previous = previousNumber.asDouble,
              let current = currentNumber.asDouble,
              let operation = currentOperation else { return }
        
        var res: Double = 0.0
        switch operation {
        case .add:
            res = previous + current
            print("Item will be add, previous: \(previous), current: \(current), result: \(res)")
        case .subtract:
            res = previous - current
        case .multiply:
            res = previous * current
        case .divide:
            if current == 0 {
                currentNumber = "Error"
                return
            }
            res = previous / current
            
            let isMaxDigits = String(Int(res)).count >= 9
            
            if isMaxDigits {
                let roundedRes = round(res)
                inputText = "\(Int(roundedRes))"
            } else {
                inputText = formatText(String(res))
                print("InputText divided = \(inputText)")
            }
            
        case .none:
            return
        }
        
        if operation != .divide {
            inputText = formatText(String(res))
        }

        lastOperand = inputText
        lastOperation = currentOperation
        
        currentNumber = inputText.replacingOccurrences(of: " ", with: "")
        previousNumber = ""
        currentOperation = Operation.none
    }

    private func formatText(_ text: String) -> String {
        var isNegative = false
        var textToFormat = text
        
        if textToFormat.hasPrefix("-") {
            isNegative = true
            textToFormat.removeFirst()
        }
        
        let components = textToFormat.components(separatedBy: ".")
        var integerPart = components[0]
        var decimalPart = components.count > 1 ? components[1] : ""
        
        // Determine number of decimal places based on length of integer part
        let integerLength = integerPart.count
        var decimalPlaces = 0
        
        switch integerLength {
        case 1:
            decimalPlaces = 8
        case 2:
            decimalPlaces = 7
        case 3:
            decimalPlaces = 6
        case 4:
            decimalPlaces = 5
        case 5:
            decimalPlaces = 4
        default:
            decimalPlaces = 1
        }
        
        // Truncate decimal part if needed
        if decimalPart.count > decimalPlaces {
            decimalPart = String(decimalPart.prefix(decimalPlaces))
        }
        
        // Remove trailing zeros from decimal part
        decimalPart = decimalPart.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
        
        // If decimal part becomes empty after trimming, remove the decimal point
        if decimalPart.isEmpty {
            let formattedNumber = integerPart
        } else {
            let formattedNumber = "\(integerPart).\(decimalPart)"
        }
        
        // Format the integer part with spaces
        let reversedIntegerPart = String(integerPart.reversed())
        var formattedIntegerPart = ""
        
        for (index, character) in reversedIntegerPart.enumerated() {
            if index != 0 && index % 3 == 0 {
                formattedIntegerPart.append(" ")
            }
            formattedIntegerPart.append(character)
        }
        
        let finalIntegerPart = String(formattedIntegerPart.reversed())
        var finalText = isNegative ? "-\(finalIntegerPart)" : finalIntegerPart
        
        if !decimalPart.isEmpty {
            finalText.append(".\(decimalPart)")
        }
        
        return finalText
    }

    
    private func calculateWithLastOperation(){
        guard let lastOp = lastOperation,
              let lastOpNumber = lastOperand.asDouble,
              let lastResult = currentNumber.asDouble
        else { return }
        
        var res: Double = 0.0
        switch lastOp {
        case .add:
            res = lastResult + lastOpNumber
        case .subtract:
            res = lastResult - lastOpNumber
        case .multiply:
            res = lastResult * lastOpNumber
        case .divide:
            if lastOpNumber == 0 {
                currentNumber = "Error"
                return
            }
            res = lastResult / lastOpNumber
        case .none:
            return
        }
    
        inputText = res.customFormatted
        currentNumber = inputText.replacingOccurrences(of: " ", with: "")
    }
    
    private func clear() {
        currentNumber = ""
        previousNumber = ""
        currentOperation = Operation.none
        inputText = "0"
    }
    
    private func toggleSign() {
        if currentNumber.hasPrefix("-") {
            currentNumber.removeFirst()
        } else {
            currentNumber = "-" + currentNumber
        }
        inputText = setupText(text: currentNumber)
    }
    
    private func calculatePercentage() {
        if var number = currentNumber.asDouble {
            number = number / 100
            currentNumber = number.customFormatted
            inputText = setupText(text: currentNumber)
        }
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
            if currentOperation != Operation.none {
                calculate()
            }
            else if !currentNumber.isEmpty {
                calculateWithLastOperation()
            }
        case "AC":
            clear()
        case "±":
            toggleSign()
        case "%":
            calculatePercentage()
        default:
            break
        }
    }
}
