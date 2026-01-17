//
//  MainScreenViewModel.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//
internal import Combine
import Foundation
import SwiftUI

class MainScreenViewModel : ObservableObject {
    @ObservedObject private var board : Board
    @State private var players: [Player]
    @Published var currentPlayer: Int
    
    init(AI: Bool) {
        self.board = Board()
        self.players = [Player(num: 0), (!AI ? Player(num: 1) : Player(num: 1))]
        self.currentPlayer = 0
    }
    
    func getCurrentPlayerName() -> String {
        return players[currentPlayer].getName()
    }
    
    func getBoard() -> Board {
        return board
    }

}
