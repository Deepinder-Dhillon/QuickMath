//
//  problems_generator.swift
//  QuickMath
//
//  Created by Deepinder on 2024-10-05.
//


import SwiftUI
import Foundation
import CoreML

struct MathProblem: Codable {
    let firstNumber: Int
    let secondNumber: Int
    let thirdNumber: Int?
    let firstOperator: String
    let secondOperator: String?
}

class MathProblemViewModel: ObservableObject {
    
    func generateAndSaveProblems() {
        let numProblemsPerDifficulty = 200
        
        for difficulty in 1...5 {
            var problems: [MathProblem] = []
            while problems.count < numProblemsPerDifficulty {
                 let problem = createMathQuestion(difficulty: difficulty)
                    problems.append(problem)
                    print("Problem for difficulty \(difficulty) added. Total now: \(problems.count)")
                
            }
            saveProblemsToFile(problems, difficulty: difficulty)
            print("Problems for difficulty \(difficulty) saved successfully.")
        }
    }
    
    private func createMathQuestion(difficulty: Int) -> MathProblem {
        let operators = ["+", "-", "*", "/"]
        let numberRange = 1...50
        
        repeat {
            var firstNumber = Int.random(in: numberRange)
            var secondNumber = Int.random(in: numberRange)
            var thirdNumber: Int?
            var secondOperator: String?
            let numOperands = Int.random(in: 2...3)
            let firstOperator = operators.randomElement()!
            
            var correctAnswer = 0
            var actualDifficulty = -1
            
            if numOperands == 2 {
                if firstOperator == "/" {
                    secondNumber = Int.random(in: 2...10)
                    firstNumber = secondNumber * Int.random(in: 1...10)
                }
                
                correctAnswer = calculateResult(first: firstNumber, second: secondNumber, oper: firstOperator)
                actualDifficulty = predictDifficulty(first: firstNumber, second: secondNumber, third: 0,
                                                     firstOperator: firstOperator, secondOperator: "", correctAnswer: Double(correctAnswer))
                
                if difficulty == actualDifficulty && (-20...90).contains(correctAnswer) {
                    return MathProblem(firstNumber: firstNumber, secondNumber: secondNumber,
                                        thirdNumber: nil, firstOperator: firstOperator, secondOperator: nil)
                }
            } else if numOperands == 3 {
                thirdNumber = Int.random(in: numberRange)
                secondOperator = operators.randomElement()!
                
                if firstOperator == "/" {
                    secondNumber = Int.random(in: 2...10)
                    firstNumber = secondNumber * Int.random(in: 1...10)
                }
                
                if secondOperator == "/" {
                    thirdNumber = Int.random(in: 2...10)
                    correctAnswer = calculateResult(first: firstNumber, second: secondNumber, oper: firstOperator)
                    if (correctAnswer % thirdNumber! != 0) {
                        continue // Skip if division would result in a fraction
                    }
                }
                
                correctAnswer = calculateResult(first: firstNumber, second: secondNumber, oper: firstOperator)
                correctAnswer = calculateResult(first: correctAnswer, second: thirdNumber!, oper: secondOperator!)
                
                actualDifficulty = predictDifficulty(first: firstNumber, second: secondNumber, third: thirdNumber!,
                                                     firstOperator: firstOperator, secondOperator: secondOperator!, correctAnswer: Double(correctAnswer))
                
                if difficulty == actualDifficulty && (-20...90).contains(correctAnswer) {
                    return MathProblem(firstNumber: firstNumber, secondNumber: secondNumber,
                                        thirdNumber: thirdNumber!, firstOperator: firstOperator, secondOperator: secondOperator!)
                }
            }
        } while true
    }
    
    private func saveProblemsToFile(_ problems: [MathProblem], difficulty: Int) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(problems)
            let url = getDocumentsDirectory().appendingPathComponent("math_problems_difficulty_\(difficulty).json")
            try data.write(to: url)
            print("Problems for difficulty \(difficulty) saved to \(url.path)")
        } catch {
            print("Failed to save problems for difficulty \(difficulty): \(error)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Calculate the result of the operation.
    private func calculateResult(first: Int, second: Int, oper: String) -> Int {
        switch oper {
        case "+":
            return first + second
        case "-":
            return first - second
        case "*":
            return first * second
        case "/":
            return second != 0 ? first / second : 0
        default:
            return 0
        }
    }
    
    // Predict the difficulty of the math problem.
    func predictDifficulty(first: Int, second: Int, third: Int, firstOperator: String, secondOperator: String, correctAnswer: Double) -> Int {
        do {
            let config = MLModelConfiguration()
            let model = try diff_predictor(configuration: config)
            
            let prediction = try model.prediction(
                FirstNumber: Int64(first),
                SecondNumber: Int64(second),
                ThirdNumber: Int64(third),
                FirstOperator: firstOperator,
                SecondOperator: secondOperator,
                CorrectAnswer: correctAnswer
            )
            
            let predictedValue = prediction.Difficulty
            
            switch predictedValue {
            case 0..<1.5:
                return 1
            case 1.5..<2.5:
                return 2
            case 2.5..<3.5:
                return 3
            case 3.5..<4.5:
                return 4
            case 4.5...5:
                return 5
            default:
                return 1
            }
            
        } catch {
            return 1
        }
    }
}

struct problems_GenView: View {
    @StateObject private var viewModel = MathProblemViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.generateAndSaveProblems()
            }) {
                Text("Generate and Save Problems")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    problems_GenView()
}
