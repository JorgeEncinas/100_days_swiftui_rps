//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Jorge Encinas on 6/20/25.
//

import SwiftUI

struct ContentView: View {
    let moves : [String] = ["rock", "paper", "scissors"]
    let winsAgainst : [String] = ["scissors", "rock", "paper"]
    let maxGamesAllowed : Int = 10
    @State private var currentCPUChoice = Int.random(in: 0...2)
    @State private var opponentWins : Int = 0
    @State private var currentWins : Int = 0
    @State private var gamesPlayed : Int = 0
    
    @State private var displayingSingleBattleOutcome : Bool = false
    @State private var battleOutcomeMessage : String = ""
    
    @State private var displayingWarOutcome : Bool = false
    
    var currentRank : String {
        if opponentWins == 0 {
            return "S. \n Nobody likes playing with you, selfish luck vacuum."
        } else if currentWins == 0 {
            return "C. \n You were honest with your choices, I admire that!"
        } else {
            let winRatio = Double(currentWins) / Double(opponentWins)
            if winRatio > 1 {
                return "A. \n You bested your opponent, and won the war."
            } else if winRatio < 1 {
                return "B. \n The war was lost, but it's just Rock-Paper-Scissors"
            } else {
                return "B. \n A perfect tie, you both return to your lands to strategize."
            }
        }
    }
    
    func battleOpponent(humanChoice : Int) {
        if humanChoice == currentCPUChoice {
            battleOutcomeMessage = "A Draw. Lives snuffed out, you wonder if it was worth it, starting this war."
        } else if winsAgainst[humanChoice] == moves[currentCPUChoice] {
            battleOutcomeMessage = "You won this battle. But what did you really stand to gain?"
            currentWins += 1
        } else {
            battleOutcomeMessage = "You lost, but then again, you already had."
            opponentWins += 1
        }
        gamesPlayed += 1
        displayingSingleBattleOutcome = true //prompt the alert to show up
    }
    
    func restartGame() {
        gamesPlayed = 0
        opponentWins = 0
        currentWins = 0
        displayingWarOutcome = false
    }
    
    func makeNextCPUMove() {
        displayingSingleBattleOutcome = false
        if gamesPlayed >= maxGamesAllowed {
            displayingWarOutcome = true
        } else {
            currentCPUChoice = Int.random(in:0...2)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(
             //gradient: Gradient(
             //    colors: [.blue, .purple]
             //),
                stops: [
                    Gradient.Stop(color: .blue, location: 0.2),
                    Gradient.Stop(color: .purple, location: 0.9),
                    
                ],
                 center: .bottom,
                 startRadius: 200,
                 endRadius: 700
            ).ignoresSafeArea()
            VStack {
                Spacer()
                Text("R 🪨 P 📄 S ✂️")
                    .fontWeight(.bold)
                    .font(.custom("Arial", size:48))
                    .foregroundStyle(.primary)
                    .frame(alignment: .center)
                    .multilineTextAlignment(.center)
                
                Text("Score: 🙂 \(currentWins) | 🤖 \(opponentWins) ")
                    .font(.custom("Arial", size:36))
                    .fontWeight(.bold)
                Spacer()
                Text("🤖: \(moves[currentCPUChoice])")
                VStack {
                    
                    VStack {
                        Text("Choose your weapon")
                            .fontWeight(.bold)
                            .font(.title)
                        ForEach(0..<3, id:\.self) { (intChoice : Int) in
                            Button {
                                battleOpponent(humanChoice: intChoice)
                            } label: {
                                Text(moves[intChoice].uppercased())
                                    .padding()
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .background(
                                        moves[intChoice] == "rock"
                                        ? Color(red: 38/255, green: 38/255, blue: 38/255)
                                            : moves[intChoice] == "paper"
                                                ? Color(red: 227/255, green: 227/255, blue: 227/255)
                                                : Color(red: 237/255, green: 130/255, blue: 130/255),
                                        in: RoundedRectangle(cornerRadius: 20))
                            }
                            .foregroundStyle(
                                moves[intChoice] == "rock"
                                ? .white
                                    : moves[intChoice] == "paper"
                                ? .black
                                : .white
                            )
                        }
                    }
                    
                    
                }
                .frame(width: 340)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                Spacer()
                Spacer()
            }
        }.frame(maxWidth:.infinity, maxHeight:.infinity)
            .alert("Battle over", isPresented: $displayingSingleBattleOutcome) {
                Button("Continue", action: makeNextCPUMove)
            } message: {
                VStack {
                    Text("🤖 chose: \(moves[currentCPUChoice]) \n \(battleOutcomeMessage)")
                }
            }
            .alert("Score: \(currentWins)/\(opponentWins)", isPresented: $displayingWarOutcome) {
                Button("Wage another war", action: restartGame)
            } message: {
                VStack {
                    Text("Rank: \(currentRank)")
                }
            }
    }
}

#Preview {
    ContentView()
}
