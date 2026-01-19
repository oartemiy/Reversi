//
//  SettingsViewModel.swift
//  Reversi
//
//  Created by Артемий Образцов on 18.01.2026.
//

internal import Combine
import Foundation

class SettingsViewModel: ObservableObject {
    @Published var AI = false
    @Published var AILevel: String = "Easy"
    @Published var startGame = false
    @Published var player1Name: String = "Player 1"
    @Published var player2Name: String = "Player 2"
}
