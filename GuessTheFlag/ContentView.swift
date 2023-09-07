//
//  ContentView.swift
//  Project2-GuessTheFlag
//
//  Created by Maciej Wiącek on 16/08/2023.
//

import SwiftUI

struct FlagImage: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct LargeBlueFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(LargeBlueFont())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var showingRestart = false
    @State private var currentRound = 1
    let roundsCount = 8
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var isFlagSelected = false
    @State private var userPick = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops:[
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .titleStyle()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flag: countries[number])
                        }
                        .rotation3DEffect(
                            userPick == number && isFlagSelected ? .degrees(360) : .degrees(0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .opacity(userPick != number && isFlagSelected ? 0.25 : 1)
                        .scaleEffect(userPick != number && isFlagSelected ? 0.75 : 1)
                        .animation(isFlagSelected ? .default : nil, value: isFlagSelected)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        .alert(scoreTitle, isPresented: $showingRestart) {
            Button("Restart", action: restart)
        } message: {
            Text("You scored \(userScore)/\(roundsCount) points!")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        isFlagSelected = true
        userPick = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            userScore -= 1
        }
        currentRound += 1
    
        
        if currentRound <= roundsCount {
            showingScore = true
        } else {
            showingRestart = true
        }
    }
    
    func askQuestion() {
        isFlagSelected = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restart() {
        userScore = 0
        currentRound = 1
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
