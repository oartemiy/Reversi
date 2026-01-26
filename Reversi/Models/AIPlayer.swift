//
//  AIPlayer.swift
//  Reversi
//
//  Created by Артемий Образцов on 19.01.2026.
//

internal import Combine
import Foundation

func getOpositeColor(color: Character) -> Character {
    if color == "W" {
        return "B"
    } else if color == "B" {
        return "W"
    } else {
        return "0"
    }
}

class AIPlayer: Player {
    @Published private var board: Board
    
    init(name: String, num: Int, board : Board) {
        self.board = board
        super.init(name: name, num: num)
    }
    
    func chooseCellAIEasy() -> Cell {
        let aliviableCells = board.showAviableCells(color: self.getColor())
        var countFigures: [(Cell, Int)] = [] // second param is difference of figures
        for cell in aliviableCells {
            let tryMoveBoard = Board(otherBoard: Board(otherBoard: board))
            do {
                try tryMoveBoard.makeMove(row: cell.x, col: cell.y, color: self.getColor())
                countFigures.append((cell, tryMoveBoard.getScore(color: self.getColor()) - tryMoveBoard.getScore(color: getOpositeColor(color: self.getColor()))))
            } catch {
                print("Error")
            }
        }
        countFigures.sort(by: { (lhs: (Cell, Int), rhs: (Cell, Int)) -> Bool in
            return lhs.1 > rhs.1
        })
        if countFigures.isEmpty {
            return aliviableCells[0]
        }
        return countFigures[0].0
    }
    
    func chooseCellAIHard() -> Cell {
        // first move
        let aliviableCells = board.showAviableCells(color: self.getColor())
        var countFigures: [(Cell, Int)] = []
        for cell in aliviableCells {
            let tryMoveBoard = Board(otherBoard: board)
            do {
                // prediction
                try tryMoveBoard.makeMove(row: cell.x, col: cell.y, color: self.getColor())
                let guessPlayer = AIPlayer(name: "__tmp__", num: tryMoveBoard.getScore(color: getOpositeColor(color: self.getColor())), board: tryMoveBoard)
                let guessCell = guessPlayer.chooseCellAIEasy()
                do {
                    try tryMoveBoard.makeMove(row: guessCell.x, col: guessCell.y, color: guessPlayer.getColor())
                    // answer
                    let predictionPlayer = AIPlayer(name: "__tmp__", num: tryMoveBoard.getScore(color: self.getColor()), board: tryMoveBoard)
                    let answerCell = predictionPlayer.chooseCellAIEasy()
                    do {
                        try tryMoveBoard.makeMove(row: answerCell.x, col: answerCell.y, color: self.getColor())
                        countFigures.append((cell, tryMoveBoard.getScore(color: self.getColor()) - tryMoveBoard.getScore(color: getOpositeColor(color: self.getColor()))))
                    } catch {
                        print("Error")
                    }
                } catch {
                    print("Error")
                }
                
            } catch {
                print("Error")
            }
        }
        countFigures.sort(by: { (lhs: (Cell, Int), rhs: (Cell, Int)) -> Bool in
            return lhs.1 > rhs.1
        })
        if countFigures.isEmpty {
            return aliviableCells.randomElement()!
        }
        return countFigures[0].0
    }

}
