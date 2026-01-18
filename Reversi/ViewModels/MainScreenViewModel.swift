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
    @Published private var players: [Player]
    @Published var currentPlayer: Int
    @State private var AI: Bool
    @Published private var error: Error? = nil

    init(AI: Bool) {
        self.AI = AI
        self.board = Board()
        self.players = [
            Player(name: "", num: 0),
            (!AI ? Player(name: "", num: 1) : Player(name: "", num: 1)),
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

    func getPlayers() -> [Player] {
        return players
    }

    func getCurrentPlayer() -> Player {
        return players[currentPlayer]
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
            for i in 0..<2 {
                players[i].setCntFigures(
                    cnt: board.getScore(color: players[i].getColor())
                )
            }
            players.sort(by: { $0.getCntFigures() > $1.getCntFigures() })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.board.makeChangeValueDefault()
            }
        } catch BoardError.NotEmptyField {
            error = BoardError.NotEmptyField
            return
        } catch BoardError.NotNearOponent {
            error = BoardError.NotNearOponent
            return
        } catch BoardError.MoveNotAvailable {
            error = BoardError.MoveNotAvailable
            currentPlayer = (currentPlayer + 1) % 2
            return
        } catch {
            return
        }
    }

}
