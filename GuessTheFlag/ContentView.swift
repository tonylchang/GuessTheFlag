//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tony Chang on 8/14/24.
//

import SwiftUI

struct ContentView: View {

    @State private var showingAlert = false
    @State private var showingScore = false
    @State private var scoreTitle = ""

    @State private var showingGameOver = false
    @State private var gameOverTitle = ""

    @State private var playerScore = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var numberOfRounds = 8
    @State private var currentRound = 1
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()
                Text("Score: \(playerScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Round \(currentRound) / \(numberOfRounds)")
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                        }
                        .clipShape(.capsule)
                        .shadow(radius: 5)
                    }
                }
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        }
        .alert(gameOverTitle, isPresented: $showingGameOver) {
            Button("New Game", action: newGame)
        }

    }
    
    func flagTapped(_ number: Int) {
        if currentRound == (numberOfRounds) {
            playerScore += (number == correctAnswer) ? 1 : 0
            gameOverTitle = "Game over! Final score: \(playerScore)"
            showingGameOver = true
        } else if number == correctAnswer {
            playerScore += 1
            scoreTitle = "Correct!"
            currentRound += 1
            showingScore = true
        } else {
            scoreTitle = "Wrong, that's \(countries[number])!"
            currentRound += 1
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func newGame() {
        currentRound = 0
        playerScore = 0
    }
    
}

#Preview {
    ContentView()
}
