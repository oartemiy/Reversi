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
    @Published private var error: BoardError? = nil
    @Published private var AILevel: String? = nil

    init(AI: Bool, AILevel: String, name1: String, name2: String) {
        self.AI = AI
        if AI {
            self.AILevel = AILevel
        }
        self.board = Board()
        self.players = [
            Player(name: name1, num: 0),
            (!AI
                ? Player(name: name2, num: 1)
                : Player(
                    name: "AI (\(AILevel)\(AILevel == "Easy" ? "😇" : "😈"))",
                    num: 1
                )),
        ]
        self.currentPlayer = 0
    }

    func getCurrentPlayerName() -> String {
        return players[currentPlayer].getName()
    }

    func getBoard() -> Board {
        return board
    }

    func getError() -> BoardError? {
        return error
    }

    func getPlayers() -> [Player] {
        return players
    }

    func getCurrentPlayer() -> Player {
        return players[currentPlayer]
    }

    func checkGameOver() -> Bool {
        return
            (!board.isMoveAviable(color: "W")
            && !board.isMoveAviable(color: "B"))
            || (board.getScore(color: "B") + board.getScore(color: "W") == Board
                .SIZE * Board.SIZE)
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
            if players[0].getCntFigures() < players[1].getCntFigures() {
                players.reverse()
                currentPlayer = (currentPlayer + 1) % 2
            }
            if checkGameOver() {
                error = BoardError.EndGame
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
