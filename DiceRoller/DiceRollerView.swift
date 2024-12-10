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
    @State private var currentRollTotal = 0
    @State private var isRolling = false
    @State private var animatedRollValue = 0
    
    @ObservedObject var historyManager: RollHistoryManager
    
    private var diceTypes = DiceType.allCases
    
    init(historyManager: RollHistoryManager) {
        self.historyManager = historyManager
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        Picker("Number of dice", selection: $numberOfDice) {
                            ForEach(1...10, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        
                        Picker("Dice type", selection: $selectedDiceType) {
                            ForEach(diceTypes) { diceType in
                                Text(diceType.name).tag(diceType)
                            }
                        }
                    }
                    
                    Section {
                        VStack {
                            Text("Roll result")
                                .font(.headline)
                            Text("\(isRolling ? animatedRollValue : currentRollTotal)")
                                .font(.system(size: 72))
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .listRowInsets(EdgeInsets())
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
                .listRowInsets(EdgeInsets())
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                Divider()
                    .padding(.bottom)
            }
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
    DiceRollerView(historyManager: RollHistoryManager())
} 
