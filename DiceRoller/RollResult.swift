//
//  RollResult.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import Foundation

struct RollResult: Codable, Identifiable {
    let id: UUID
    let diceType: Int
    let numberOfDice: Int
    let total: Int
    let timestamp: Date
    
    init(diceType: Int, numberOfDice: Int, total: Int) {
        self.id = UUID()
        self.diceType = diceType
        self.numberOfDice = numberOfDice
        self.total = total
        self.timestamp = Date()
    }
}