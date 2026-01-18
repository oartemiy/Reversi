//
//  MainScreenViewModel.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//
internal import Combine
import Foundation
import SwiftUI

class MainScreenViewModel: ObservableObject {
    @ObservedObject private var board: Board
    @State private var players: [Player]
    @Published var currentPlayer: Int
    @State private var AI: Bool
    @Published private var error: Error? = nil

    init(AI: Bool) {
        self.AI = AI
        self.board = Board()
        self.players = [
            Player(num: 0), (!AI ? Player(num: 1) : Player(num: 1)),
        ]
        self.currentPlayer = 0
    }

    func getCurrentPlayerName() -> String {
        return players[currentPlayer].getName()
    }

    func getBoard() -> Board {
        return board
    }

    func getError() -> Error? {
        return error
    }

    func makePlayerMove(row: Int, col: Int) {
        do {
            try board.makeMove(
                row: row,
                col: col,
                color: players[currentPlayer].getColor()
            )
            error = nil
            currentPlayer = (currentPlayer + 1) % 2
        } catch BoardError.NotEmptyField {
            error = BoardError.NotEmptyField
            return
        } catch BoardError.NotNearOponent {
            error = BoardError.NotNearOponent
            return
        } catch {
            return
        }
    }

}
