//
//  ContentView.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var historyManager = RollHistoryManager()
    
    var body: some View {
        TabView {
            DiceRollerView(historyManager: historyManager)
                .tabItem {
                    Label("Dice", systemImage: "dice")
                }
            
            RollHistoryView(historyManager: historyManager)
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }
    }
}

#Preview {
    ContentView()
}
