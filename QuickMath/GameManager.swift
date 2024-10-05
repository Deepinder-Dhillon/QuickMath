import Foundation
import Observation


@Observable class GameManager {
    // Properties to track the current question, score, high score, remaining time, game status, and answer state
    var question = MathQuestion(score: 0)    // The current question based on the player's score
    var score = 0                            // The player's current score
    var highScore = 0                        // The highest score achieved
    var timeRemaining = 30                   // Time remaining in seconds for the game
    var isGameOver = false                   // Flag to track if the game is over
    var selectedAnswer: Int? = nil           // The answer selected by the player
    var isCorrectAnswer: Bool = false        // Flag to track if the player's answer is correct
    var isProcessingAnswer = false           // Flag to prevent multiple answers being processed at the same time

    // Method to check if the player's answer is correct
    func checkAnswer(_ answer: Int) {
        guard !isGameOver else { return }
        guard !isProcessingAnswer else { return }

        isProcessingAnswer = true
        selectedAnswer = answer                     // Store the player's selected answer

        // Check if the selected answer is correct
        if question.checkAnswer(answer) {
            isCorrectAnswer = true                  // Mark answer as correct
            score += 1                              // Increment the player's score
            timeRemaining += 1                      // Add extra time for a correct answer

            // Update the high score if the current score higher then previous high score
            if score > highScore {
                highScore = score
            }
        } else {
            isCorrectAnswer = false                 // Mark answer as incorrect
            if timeRemaining > 0 {
                timeRemaining -= 5                  // Reduce time for incorrect answers
            }
        }
        
        // Check if the game is over due to time running out
        if timeRemaining <= 0 {
            gameOver()
        } else {
            // Delay for 0.5 seconds before moving to the next question
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.question = MathQuestion(score: self.score)   // Generate a new question based on the updated score
                self.selectedAnswer = nil
                self.isProcessingAnswer = false
            }
        }
    }

    // Method to handle when the game is over
    func gameOver() {
        isGameOver = true
        isProcessingAnswer = false
    }

    // Method to restart the game
    func restartGame() {
        score = 0                       // Reset the score
        timeRemaining = 30              // Reset the timer
        question = MathQuestion(score: score)  // Generate a new question with the initial score
        isGameOver = false              // Mark that the gameover to false
        selectedAnswer = nil            // Reset the selected answer
        isProcessingAnswer = false
    }
    
    // Method to decrese the time
    func decrementTime() {
        if timeRemaining > 0 {
            timeRemaining -= 1           // Decrease the remaining time by 1 second
        } else {
            gameOver()                   // End the game if time runs out
        }
    }
}


struct MathQuestion {
    let firstNumber: Int
    let secondNumber: Int
    let thirdNumber: Int
    let firstOperator: String
    let secondOperator: String
    let correctAnswer: Int
    let options: [Int]

    // Init math question based on the player's score
    init(score: Int) {
        // Load the JSON files for different difficulty levels
        let difficulty1 = loadJSONFile(filename: "math_problems_difficulty_1")
        let difficulty2 = loadJSONFile(filename: "math_problems_difficulty_2")
        let difficulty3 = loadJSONFile(filename: "math_problems_difficulty_3")
        let difficulty4 = loadJSONFile(filename: "math_problems_difficulty_4")
        let difficulty5 = loadJSONFile(filename: "math_problems_difficulty_5")
        
        var selectedProblem: [Any]
        
        // Select  problem based on the player score
        switch score {
        case 0..<3:
            selectedProblem = difficulty1.randomElement()!
        case 3..<6:
            selectedProblem = difficulty2.randomElement()!
        case 6..<8:
            selectedProblem = difficulty3.randomElement()!
        case 8..<10:
            selectedProblem = difficulty4.randomElement()!
        case 10...:
            selectedProblem = difficulty5.randomElement()!
        default:
            selectedProblem = difficulty1.randomElement()!
        }
        
        // Assign numbers and operators
        self.firstNumber = selectedProblem[0] as! Int
        self.secondNumber = selectedProblem[1] as! Int
        self.thirdNumber = (selectedProblem[2] as! Int)
        self.firstOperator = selectedProblem[3] as! String
        self.secondOperator = (selectedProblem[4] as! String)
        
        // Calculate the correct answer
        self.correctAnswer = MathQuestion.calculateAnswer(
            firstNumber: firstNumber,
            firstOperator: firstOperator,
            secondNumber: secondNumber,
            secondOperator: secondOperator,
            thirdNumber: thirdNumber
        )
        
        // Generate 4 options including the correct answer
        self.options = MathQuestion.generateOptions(correctAnswer: correctAnswer)
    }

    // Method to generate a list of 4 unique options (including the correct answer)
    static func generateOptions(correctAnswer: Int) -> [Int] {
        var options = [correctAnswer]
        
        // Add 3 random options from 0 to 99
        while options.count < 4 {
            let randomOption = Int.random(in: 0...99)
            if randomOption != correctAnswer && !options.contains(randomOption) {
                options.append(randomOption)
            }
        }
        
        return options.shuffled()
    }

    // Calculate correct answer based on the operators and numbers
    static func calculateAnswer(firstNumber: Int, firstOperator: String, secondNumber: Int, secondOperator: String, thirdNumber: Int) -> Int {
        
        // Perform the first operation (firstNumber op secondNumber)
        var result = performOperation(lhs: firstNumber, rhs: secondNumber, op: firstOperator)
        
        // If there's a second operator and a third number, perform the second operation
        if (secondOperator != ""){
            result = performOperation(lhs: result, rhs: thirdNumber, op: secondOperator)
        }
        
        // Return the result
        return result
    }

    // Helper function to perform the actual math operation based on the operator symbol
    static func performOperation(lhs: Int, rhs: Int, op: String) -> Int {
        switch op {
        case "+":
            return lhs + rhs
        case "-":
            return lhs - rhs
        case "*":
            return lhs * rhs
        case "/":
            return  lhs / rhs
        default:
            return lhs
        }
    }

    // Method to check if the user's answer is correct
    func checkAnswer(_ answer: Int) -> Bool {
        return answer == correctAnswer
    }
}


func loadJSONFile(filename: String) -> [[Any]] {
    
    // load the file
    let url = Bundle.main.url(forResource: filename, withExtension: "json")!
    let data = try! Data(contentsOf: url)
    
    // Decode as an array of dictionaries
    let jsonArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
    
    // Convert the JSON array to a 2D array of integers
       var result: [[Any]] = []
       for item in jsonArray {
           //convert each key's value, defaults where value is not present
           let firstNumber = item["firstNumber"] as? Int ?? 0
               let secondNumber = item["secondNumber"] as? Int ?? 0
               let thirdNumber = item["thirdNumber"] as? Int  ?? 0
               let firstOperator = item["firstOperator"] as? String ?? ""
               let secondOperator = item["secondOperator"] as? String ?? "" 
           
           // Append the values to the result array
           result.append([firstNumber, secondNumber, thirdNumber, firstOperator, secondOperator])
       }
       
       return result
}
