//
//  DiceRollerView.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import SwiftUI

struct DiceRollerView: View {
    @State private var numberOfDice = 1
    @State private var selectedDiceType: DiceType = .d6
    @State private var diceResults: [Int] = [0]  // Array to store individual die results
    @State private var isRolling = false
    @State private var animatedRollValues: [Int] = [0]  // Array for animation
    
    @ObservedObject var historyManager: RollHistoryManager
    
    private var diceTypes = DiceType.allCases
    
    init(historyManager: RollHistoryManager) {
        self.historyManager = historyManager
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    Picker("Number of dices", selection: $numberOfDice) {
                        ForEach(1...10, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .onChange(of: numberOfDice) {
                        diceResults = Array(repeating: 0, count: numberOfDice)
                        animatedRollValues = Array(repeating: 0, count: numberOfDice)
                    }
                    
                    Picker("Dice type", selection: $selectedDiceType) {
                        ForEach(diceTypes) { diceType in
                            Text(diceType.name).tag(diceType)
                        }
                    }
                }
                
                Section {
                    ForEach(0..<numberOfDice, id: \.self) { index in
                        VStack {
                            Text("Dice \(index + 1)")
                                .font(.headline)
                            Text("\(isRolling ? animatedRollValues[index] : diceResults[index])")
                                .font(.system(size: 72))
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("DiceRoller")
            .navigationBarTitleDisplayMode(.inline)
            
            Button(action: rollDice) {
                Text("Roll dice")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isRolling)
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Divider()
        }
    }
    
    private func rollDice() {
        isRolling = true
        diceResults = Array(repeating: 0, count: numberOfDice)
        animatedRollValues = Array(repeating: 0, count: numberOfDice)
        
        var rollCount = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            // Animate each die individually
            for i in 0..<numberOfDice {
                animatedRollValues[i] = Int.random(in: 1...selectedDiceType.rawValue)
            }
            rollCount += 1
            
            if rollCount >= 10 {
                timer.invalidate()
                
                // Final results for each die
                diceResults = (0..<numberOfDice).map { _ in
                    Int.random(in: 1...selectedDiceType.rawValue)
                }
                
                // Save the total to history
                let result = RollResult(
                    diceType: selectedDiceType.rawValue,
                    numberOfDice: numberOfDice,
                    total: diceResults.reduce(0, +)
                )
                historyManager.saveRoll(result)
                
                isRolling = false
            }
        }
        timer.fire()
    }
}

#Preview {
    DiceRollerView(historyManager: RollHistoryManager())
}
