//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tony Chang on 8/14/24.
//

import SwiftUI

struct BigBlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundStyle(.blue)
            .padding()
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func bigBlueTitleStyle() -> some View {
        modifier(BigBlueTitle())
    }
}

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
    
    @State private var animationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0

    @State private var selectedFlag: Int? = nil
    @State private var displayOpacity = false
    @State private var scaleDown = false

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.6, green: 0.7, blue: 0.75), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.5, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .bigBlueTitleStyle()
                Spacer()
                Text("Score: \(playerScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Round \(currentRound) / \(numberOfRounds)")
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation {
                                flagTapped(number)
                                animationAmount += 360
                            }
                        } label: {
                            FlagImage(number)
                        }
                        .opacity( 
                            displayOpacity ? (selectedFlag == number ? opacityAmount : 0.25) : 1.0
                        )
                        .rotation3DEffect(
                            .degrees((selectedFlag == number) ? animationAmount : 0.0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .scaleEffect(scaleDown ? (selectedFlag == number ? 1 : 0.5) : 1)
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
    
    func FlagImage(_ number: Int) -> some View {
        return Image(countries[number])
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        displayOpacity = true
        scaleDown = true
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
        selectedFlag = nil
        displayOpacity = false
        scaleDown = false
    }
    
    func newGame() {
        currentRound = 0
        playerScore = 0
        askQuestion()
    }
    
}

#Preview {
    ContentView()
}
