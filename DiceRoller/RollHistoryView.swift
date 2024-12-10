//
//  RollHistoryView.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import SwiftUI

struct RollHistoryView: View {
    @ObservedObject var historyManager: RollHistoryManager
    
    var body: some View {
        List {
            ForEach(historyManager.rollHistory) { roll in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(roll.numberOfDice)d\(roll.diceType)")
                            .font(.headline)
                        Text(roll.timestamp, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(roll.total)")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        }
        .navigationTitle("Roll history")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear history") {
                    historyManager.clearHistory()
                }
            }
        }
    }
}
