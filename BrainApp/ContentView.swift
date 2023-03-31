//
//  ContentView.swift
//  BrainApp
//
//  Created by MAC on 08/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    var gameCollections:[String:String] = ["Rock":"🪨", "Paper":"📃", "Scissors":"✂️"]
    
    @State var gameItems: [String] // Declare the gameItems property
    init() {
        gameItems =  Array(gameCollections.keys).shuffled() // Initialize the gameItems in init and Shuffle the keys
    }
    
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var points = 0
    @State var totalPoints = 0
    @State var trials = 0
    @State var dismissButtonText = ""
    @State var remark = " "
    @State var gameOver = false
    @State var randomNumber = Int.random(in: 0...2)
    @State var randomBool = Bool.random()
    
    
    var givenItem: String {
        return gameItems[randomNumber]
    }
    
    
    enum gameMove:String {
        case win = "win"
        case lose = "defeat"
    }
    
    
    
    var randomGameMove: gameMove {
      randomBool ? .win : .lose
    }
    
    
    
    var body: some View {
        NavigationView {
            ZStack{
                
                Color(red: 0.56, green: 0.47, blue: 0.77).ignoresSafeArea()

                VStack(alignment: .center, spacing:20){
                    Text("THE BRAIN GAME🧠")
                        .font(.title).bold()
                    VStack(alignment: .center, spacing: 25) {
                        Text("You got a \(givenItem) \(gameCollections[givenItem]!)")
                            .font(.title).bold()
                        Text("Make a \(randomGameMove.rawValue) move.")
                            .font(.title3).bold()
                        ForEach(gameItems, id:\.self) { item in
                            Button(action: {evaluateMove(item)})
                            {
                                Text(item + gameCollections[item]!)
                                    .padding()
                                    .font(.title3)
                                    .frame(width:150, height:100)
                                    .foregroundColor(.white)
                                    .background(Color(red: 0.39, green: 0.29, blue: 0.47))
                                    .clipShape(Capsule())
                            }
                        }
                        if gameOver {
                            Text("Total Points: \(totalPoints)")
                        }
                    }.padding()
                        .frame(width:330, height: 600)
                        .background(Color(red: 0.87, green: 0.75, blue: 0.98))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                }.padding(.horizontal, 48)
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message:Text(remark), dismissButton: .default(Text(dismissButtonText), action: {if gameOver {
                    resetGame()
                } else {
                    reloadUI()
                }}))
            }
        }
    }
    
    
    
    func evaluateMove(_ chosenItem: String) {
        
        trials += 1
        
        if (trials == 10) {
            gameOver = true; alertTitle = "Your Journey ends here"; remark = "You scored a total of \(totalPoints) points!"; dismissButtonText = "Play Again"
        }
        
        else {
            dismissButtonText = "Continue"
            let winRule = ["Rock":"Scissors", "Scissors":"Paper", "Paper":"Rock"]
            let loseRule = ["Scissors":"Rock", "Paper":"Scissors", "Rock":"Paper"]
            
            switch randomGameMove {
            case (.win) where chosenItem == winRule[givenItem]:
                points = 2; totalPoints += points; alertTitle = "Good Job!"; remark = "You won! You've just scored \(points) points. \(givenItem) beats \(winRule[givenItem]!)"
            case (.win) where chosenItem != winRule[givenItem]:
                points = 0; totalPoints += points; alertTitle = "Oopsie!";  remark = "You lost! No points for you dumbie! \(givenItem) beats \(winRule[givenItem]!)"
            case (.lose) where chosenItem == loseRule[givenItem]:
                points = 2; totalPoints += points; alertTitle = "Good Job!";  remark = "You won! You've just scored \(points) points. \(givenItem) loses to \(winRule[givenItem]!)"
            default:
                points = 0; totalPoints += points; alertTitle = "Oopsie!"; remark = "You lost! No points for you dumbie! \(givenItem) loses to \(loseRule[givenItem]!)"
            }
        }
        
        showingAlert = true
    }
    
    
    
    func reloadUI() {
        let oldGivenItem = givenItem
        
        randomBool = Bool.random()
        gameItems.shuffle()
        
        while(oldGivenItem == givenItem) {
            randomNumber = Int.random(in: 0...2)
        }
    }
    
    
    func resetGame() {
         showingAlert = false
         alertTitle = ""
         points = 0
         totalPoints = 0
         trials = 0
         dismissButtonText = ""
         remark = " "
         gameOver = false
         randomNumber = Int.random(in: 0...2)
         randomBool = Bool.random()
         gameItems.shuffle()
    }
    
}
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
    /*
     1. ways to create an array out of a dictionary keys
     gameCollections.map { $0.key }  OR   Array(gameCollections.keys)
     
     2. This is an array of of type [(key: String, value: String)]
     [("Paper", "📃"), ("Rock", "🪨"), ("Scissors", "✂️")]

     3.The second error message you're seeing, "Type 'Dictionary<String, String>.Element' (aka '(key: String, value: String)') cannot conform to 'Hashable'", is caused by the fact that the (key: String, value: String) tuple type does not conform to the Hashable protocol, which is a requirement for the id parameter in the ForEach view in SwiftUI.
     
     To fix this error, you can use the \.key key path as the id parameter, which will use the dictionary keys as the identifiers for the ForEach view.
     
     4. How to shuffle a dictionary:
     //game items is an array of keys belonging to the original dicitonary'gameCollections'. We trying to shuffle gamecollections into a new dictionary.
     var shuffledGameCollections: [String:String] {
         var newGameCollections = [String:String] ()
         
         for key in gameItems{
             if let value =  gameCollections[key] {
                  newGameCollections[key] = value
             }
         }
         return newGameCollections
     }
     
     5. GAME RULES:
     Rock beats scissors (rock crushes scissors)
     Scissors beats paper (scissors cut paper)
     Paper beats rock (paper covers rock)
     
     */

