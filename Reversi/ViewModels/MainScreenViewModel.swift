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
    @Published var AIMove: Bool = false

    init(AI: Bool, AILevel: String, name1: String, name2: String) {
        self.AI = AI
        if AI {
            self.AILevel = AILevel
        }
        self.board = Board()
        self.players = []
        self.currentPlayer = 0
        self.players = [
            Player(name: name1, num: 0),
            (!AI
                ? Player(name: name2, num: 1)
                : AIPlayer(
                    name: "AI (\(AILevel)\(AILevel == "Easy" ? "😇" : "😈"))",
                    num: 1,
                    board: self.board
                )),
        ]
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
            if AI {
                let chousedCell = AILevel == "Easy" ? (players[currentPlayer] as! AIPlayer).chooseCellAIEasy() : (players[currentPlayer] as! AIPlayer).chooseCellAIHard()
                AIMove.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + (AILevel == "Easy" ? 1.5 : 3.0)) {
                    guard !self.checkGameOver() else { return }
                    do {
                        try self.board.makeMove(row: chousedCell.x, col: chousedCell.y, color: self.players[self.currentPlayer].getColor())
                    } catch {
                        print("Error")
                    }
                    self.error = nil
                    self.currentPlayer = (self.currentPlayer + 1) % 2
                    for i in 0..<2 {
                        self.players[i].setCntFigures(
                            cnt: self.board.getScore(color: self.players[i].getColor())
                        )
                    }
                    if self.players[0].getCntFigures() < self.players[1].getCntFigures() {
                        self.players.reverse()
                        self.currentPlayer = (self.currentPlayer + 1) % 2
                    }
                    if self.checkGameOver() {
                        self.error = BoardError.EndGame
                    }
                    self.AIMove.toggle()
                }
                
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
