import SwiftUI
import CoreML


struct ContentView: View {
    var gameManager = GameManager()

    var body: some View {
        ZStack {
            BackgroundView()

            if gameManager.isGameOver {
                GameOver(score: gameManager.score, onRestart: gameManager.restartGame)
                    .transition(.scale)
            } else {
                ZStack {
                    VStack {
                        TopBackground()
                        Spacer().frame(height: 130)
                        OptionButtons(gameManager: gameManager)
                        Spacer()
                    }
                    

                    VStack {
                        Scores(gameManager: gameManager)
                        Spacer()
                    }
                    
                    QuestionBox(gameManager: gameManager)

                   

                    VStack {
                        Spacer().frame(height: 80)
                        TimerBar(gameManager: gameManager, onTimeOut: gameManager.gameOver, totalTime: 30)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
}


struct BackgroundView: View {
    var body: some View {
        
        // Background
        LinearGradient(
          gradient: Gradient(colors: [
              Color(red: 0.0588, green: 0.1255, blue: 0.2471),
              Color(red: 0.0706, green: 0.2157, blue: 0.3137),
              Color(red: 0.1020, green: 0.3059, blue: 0.4510),
              Color(red: 0.2353, green: 0.0784, blue: 0.1765),
          ]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct TopBackground: View {
    var body: some View {
        
    
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.2, blue: 0.8),
                        Color(red: 0.8, green: 0.15, blue: 0.4),
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(40)
            .edgesIgnoringSafeArea(.all)
    }
}


struct OptionButtons: View {
  var gameManager: GameManager

  var body: some View {
    ForEach(gameManager.question.options, id: \.self) { option in
      Button(action: {
        if !gameManager.isGameOver {
          withAnimation(.easeInOut(duration: 0.2)) {
            gameManager.checkAnswer(option)
          }
        }
      }) {
        Text("\(option)")
          .font(.system(size: 24, weight: .bold, design: .rounded))
          .frame(maxWidth: .infinity)
          
          .padding()
          .overlay(
                              RoundedRectangle(cornerRadius: 20)
                                .stroke(Gradient(colors: [
                                    Color(red: 0.8, green: 0.15, blue: 0.4),
                                    Color(red: 0.2, green: 0.2, blue: 0.8),
                                ]), lineWidth: 20)
                                .opacity(0.1)
                          )
          .background(
            Group {
              if gameManager.selectedAnswer == option {
                gameManager.isCorrectAnswer ? Color.green : Color.red
              } else {
                LinearGradient(
                  gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.2, blue: 0.8),
                    Color(red: 0.8, green: 0.15, blue: 0.4),
                  ]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              }
            }
          )
          
          .cornerRadius(20)
          .foregroundColor(.white)
          
          
          .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
      }
      .padding(.horizontal, 50)
      .padding(.vertical, 5)
      .disabled(gameManager.isProcessingAnswer)
    }
  }
}

struct Scores: View {
    var gameManager: GameManager
    var body: some View {
        HStack {
            Text("Score: \(gameManager.score)")
            Spacer()
            Text("HighScore:  \(gameManager.highScore)")
                .multilineTextAlignment(.trailing)
        }
        .font(.system(size: 24, weight: .bold, design: .rounded))
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

struct QuestionBox: View {
    var gameManager: GameManager
    var body: some View {
        VStack {
            Spacer().frame(height: 120)
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .frame(height: 150)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)

        
              
                Text(formattedQuestion(
                    firstNumber: gameManager.question.firstNumber,
                    firstOperator: gameManager.question.firstOperator,
                    secondNumber: gameManager.question.secondNumber,
                    secondOperator: gameManager.question.secondOperator,
                    thirdNumber: gameManager.question.thirdNumber
                ))

                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 15 / 255, green: 32 / 255, blue: 63 / 255))
                
                .padding(.top, 60)
            }
            .padding(.horizontal)
            Spacer()
        }
    }
    func formattedQuestion(firstNumber: Int, firstOperator: String, secondNumber: Int, secondOperator: String, thirdNumber: Int) -> String {
    
        
        // Create the formatted question string
        var question = "\(firstNumber) \(firstOperator) \(secondNumber)"
        
        // Add the third number and second operator if the second operator is used
        if (secondOperator != ""){
            question += " \(secondOperator) \(thirdNumber)"
        }
        
        question += " = ?"
        
        return question
    }
}

struct TimerBar: View {
  var gameManager: GameManager

  var onTimeOut: () -> Void
  let totalTime: Int

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    ZStack {
      Circle()
        .fill(
          LinearGradient(
            gradient: Gradient(colors: [
              Color(red: 0.95, green: 0.3, blue: 0.2),
              Color(red: 0.8, green: 0.15, blue: 0.4),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .frame(width: 100, height: 100)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)

      Circle()
        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
        .foregroundColor(.white)
        .opacity(0.5)
        .frame(width: 80)

      Circle()
        .trim(from: 0, to: Double(gameManager.timeRemaining) / Double(totalTime))
        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
        .foregroundColor(
          gameManager.selectedAnswer == nil ? .white : (gameManager.isCorrectAnswer ? .green : .red)
        )
        .frame(width: 80)
        .rotationEffect(.degrees(-90))


      Text("\(gameManager.timeRemaining)")
        .font(.system(size: 28, weight: .bold, design: .rounded))
        .foregroundColor(.white)
        .contentTransition(.numericText())
        .id(gameManager.timeRemaining)
    }
    .onReceive(timer) { _ in
      if gameManager.timeRemaining > 0 {
        withAnimation(.easeInOut(duration: 0.5)) {
          gameManager.decrementTime()
        }
      } else if gameManager.timeRemaining < 1 {
        onTimeOut()
      }
    }
  }
}

struct GameOver: View {
  var score: Int
  var onRestart: () -> Void

  var body: some View {
    VStack {
      Text("Game Over")
        .font(.system(size: 40, weight: .bold, design: .rounded))
        .foregroundColor(Color(red: 0.8, green: 0.15, blue: 0.4))
        .padding()

      Text("Your Score: \(score)")
        .font(.system(size: 28, weight: .bold, design: .rounded))
        .foregroundColor(Color(red: 15 / 255, green: 32 / 255, blue: 63 / 255))
        .padding()

      Button(action: {
        withAnimation(.easeInOut(duration: 0.5)) { 
          onRestart()
        }
      }) {
        Text("Restart")
          .font(.system(size: 24, weight: .bold, design: .rounded))
          .padding()
          .frame(maxWidth: .infinity)
          .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(
                LinearGradient(
                  gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.3, blue: 0.2),
                    Color(red: 0.8, green: 0.15, blue: 0.4),
                  ]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
          )
          .foregroundColor(.white)
          .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
      }
      .padding(.horizontal, 50)
      .padding(.vertical, 10)
      .transition(.opacity)
    }
    .background(
      RoundedRectangle(cornerRadius: 30)
        .fill(Color.white.opacity(0.9))
        .shadow(radius: 10)
    )
    .padding(30)
  }
}

#Preview {
  ContentView()
}
