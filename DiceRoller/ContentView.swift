//
//  ContentView.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var numberOfDice = 1
    @State private var selectedDiceType: DiceType = .d6
    @State private var currentRollTotal = 0
    @State private var isRolling = false
    @State private var animatedRollValue = 0
    
    @StateObject private var historyManager = RollHistoryManager()
    
    private var diceTypes = DiceType.allCases
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Dice Configuration Section
                GroupBox(label: Text("Dice settings")) {
                    HStack {
                        // Number of Dice Picker
                        VStack {
                            Text("Number of dice")
                            Picker("", selection: $numberOfDice) {
                                ForEach(1...10, id: \.self) { number in
                                    Text("\(number)").tag(number)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        // Dice Type Picker
                        VStack {
                            Text("Dice type")
                            Picker("", selection: $selectedDiceType) {
                                ForEach(diceTypes) { diceType in
                                    Text(diceType.name).tag(diceType)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                }
                
                // Roll Result Display
                VStack {
                    Text("Roll result")
                        .font(.headline)
                    Text("\(isRolling ? animatedRollValue : currentRollTotal)")
                        .font(.system(size: 72))
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // Roll Button
                Button(action: rollDice) {
                    Text("Roll dice")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isRolling)
                
                // History Section
                NavigationLink(destination: RollHistoryView(historyManager: historyManager)) {
                    Text("View roll history")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("DiceRoller")
        }
    }
    
    private func rollDice() {
        isRolling = true
        currentRollTotal = 0
        animatedRollValue = 0
        
        // Create timer for roll animation
        var rollCount = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            // Simulate roll animation
            animatedRollValue = Int.random(in: 1...selectedDiceType.rawValue)
            rollCount += 1
            
            // Stop animation after 10 iterations
            if rollCount >= 10 {
                timer.invalidate()
                
                // Calculate actual roll total
                currentRollTotal = (0..<numberOfDice).map { _ in
                    Int.random(in: 1...selectedDiceType.rawValue)
                }.reduce(0, +)
                
                // Create and save roll result
                let result = RollResult(
                    diceType: selectedDiceType.rawValue,
                    numberOfDice: numberOfDice,
                    total: currentRollTotal
                )
                historyManager.saveRoll(result)
                
                isRolling = false
            }
        }
        timer.fire()
    }
}

#Preview {
    ContentView()
}
