//
//  Board.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//

internal import Combine
import Foundation
import SwiftUI

class Cell: ObservableObject {
    static func != (lhs: Cell, rhs: Cell) -> Bool {
        lhs.x != rhs.x || lhs.y != rhs.y
    }
    
    var x, y: Int
    @Published var color: Character
    @Published var isChanged = false

    init() {
        self.x = 0
        self.y = 0
        self.color = "0"
    }
}

enum BoardError: Error {
    case NotEmptyField
    case NotNearOponent
    case MoveNotAvailable
}

extension BoardError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NotEmptyField: "Field is not empty, try one more time"
        case .NotNearOponent: "You shoud put your piece near an opponent piece"
        case .MoveNotAvailable: "You can't make move, your opponet move"
        }
    }

}
class Board: ObservableObject {
    static let SIZE = 8

    @Published private var cells: [[Cell]]

    private func makeDefault() {
        for i in 0..<Board.SIZE {
            for j in 0..<Board.SIZE {
                self.cells[i][j] = Cell()
                self.cells[i][j].x = i
                self.cells[i][j].y = j
                self.cells[i][j].color = "0"
            }
        }
        self.cells[3][3].color = "W"
        self.cells[3][4].color = "B"
        self.cells[4][3].color = "B"
        self.cells[4][4].color = "W"
    }

    init() {
        self.cells = (0..<Board.SIZE).map { i in
            (0..<Board.SIZE).map { j in
                let cell = Cell()
                cell.x = i
                cell.y = j
                return cell
            }
        }
        makeDefault()
    }

    func getCell(row: Int, col: Int) -> Cell {
        return cells[row][col]
    }

    func makeMove(row: Int, col: Int, color: Character) throws {
        if !isMoveAviable(color: color) {
            throw BoardError.MoveNotAvailable
        }
        if self.cells[row][col].color == "0" {
            var nearOpponents = false
            for dx in -1...1 {
                for dy in -1...1 {
                    if (dx != 0 || dy != 0) && 0 <= row + dx
                        && row + dx < Board.SIZE && 0 <= col + dy
                        && col + dy < Board.SIZE
                        && ((self.cells[row + dx][col + dy].color == "B"
                            && color == "W")
                            || (self.cells[row + dx][col + dy].color == "W"
                                && color == "B"))
                    {
                        nearOpponents = true
                    }
                }
            }
            if !nearOpponents {
                throw BoardError.NotNearOponent
            } else {
                self.cells[row][col].color = color
            }
            makeReverse(row: row, col: col, color: color)

        } else {
            throw BoardError.NotEmptyField
        }
    }
    
    func getScore(color: Character) -> Int {
        var ans = 0
        for i in 0..<Board.SIZE {
            for j in 0..<Board.SIZE {
                if self.cells[i][j].color == color {
                    ans += 1
                }
            }
        }
        return ans
    }

    func isMoveAviable(color: Character) -> Bool {
        var cntFalse = 0
        for i in 0..<Board.SIZE {
            for j in 0..<Board.SIZE {
                if self.cells[i][j].color == "0" {
                    var nearOponents = false
                    let row = i
                    let col = j
                    for dx in -1...1 {
                        for dy in -1...1 {
                            if (dx != 0 || dy != 0) && 0 <= row + dx
                                && row + dx < Board.SIZE && 0 <= col + dy
                                && col + dy < Board.SIZE
                                && ((self.cells[row + dx][col + dy].color == "B"
                                    && color == "W")
                                    || (self.cells[row + dx][col + dy].color
                                        == "W"
                                        && color == "B"))
                            {
                                nearOponents = true
                            }
                        }
                    }
                    if !nearOponents {
                        cntFalse += 1
                    }
                } else {
                    cntFalse += 1
                }
            }
        }
        return cntFalse != Board.SIZE * Board.SIZE
    }

    private func reverse(reverseCondidats: inout [Cell], color: Character) {
        if reverseCondidats.count > 2 && reverseCondidats.last?.color == color {
            for cell in reverseCondidats {
                cell.color = color
                if cell != reverseCondidats.first! && cell != reverseCondidats.last! {
                    cell.isChanged.toggle()
                }
            }
        }
        reverseCondidats = [reverseCondidats[0]]
    }

    private func makeReverse(row: Int, col: Int, color: Character) {
        var reverseCondidats: [Cell] = [self.cells[row][col]]
        // Horizontal
        // Left
        for dy in 1..<Board.SIZE {
            if col - dy < Board.SIZE && col - dy >= 0 {
                if self.cells[row][col - dy].color != "0" {
                    if self.cells[row][col - dy].color != color {
                        reverseCondidats.append(self.cells[row][col - dy])
                    } else {
                        reverseCondidats.append(self.cells[row][col - dy])
                        break
                    }
                } else {
                    break
                }
            }
        }
        reverse(reverseCondidats: &reverseCondidats, color: color)
        // Right
        for dy in 1..<Board.SIZE {
            if col + dy < Board.SIZE && col + dy >= 0 {
                if self.cells[row][col + dy].color != "0" {
                    if self.cells[row][col + dy].color != color {
                        reverseCondidats.append(self.cells[row][col + dy])
                    } else {
                        reverseCondidats.append(self.cells[row][col + dy])
                        break
                    }
                } else {
                    break
                }
            }
        }
        reverse(reverseCondidats: &reverseCondidats, color: color)

        // Vertical
        // Upper
        for dx in 1..<Board.SIZE {
            if row - dx < Board.SIZE && row - dx >= 0 {
                if self.cells[row - dx][col].color != "0" {
                    if self.cells[row - dx][col].color != color {
                        reverseCondidats.append(self.cells[row - dx][col])
                    } else {
                        reverseCondidats.append(self.cells[row - dx][col])
                        break
                    }
                } else {
                    break
                }
            }
        }
        reverse(reverseCondidats: &reverseCondidats, color: color)

        // Lower
        for dx in 1..<Board.SIZE {
            if row + dx < Board.SIZE && row + dx >= 0 {
                if self.cells[row + dx][col].color != "0" {
                    if self.cells[row + dx][col].color != color {
                        reverseCondidats.append(self.cells[row + dx][col])
                    } else {
                        reverseCondidats.append(self.cells[row + dx][col])
                        break
                    }
                } else {
                    break
                }
            }
        }
        reverse(reverseCondidats: &reverseCondidats, color: color)

        // Diagonal

        // Side
        for d in 1..<Board.SIZE {
            if row + d < Board.SIZE && row + d >= 0 && col + d < Board.SIZE
                && col + d >= 0
            {
                if self.cells[row + d][col + d].color != "0" {
                    if self.cells[row + d][col + d].color != color {
                        reverseCondidats.append(self.cells[row + d][col + d])
                    } else {
                        reverseCondidats.append(self.cells[row + d][col + d])
                        break
                    }
                } else {
                    break
                }
            }
        }
        reverse(reverseCondidats: &reverseCondidats, color: color)
        for d in 1..<Board.SIZE {
            if row - d < Board.SIZE && row - d >= 0 && col - d < Board.SIZE
                && col - d >= 0
            {
                if self.cells[row - d][col - d].color != "0" {
                    if self.cells[row - d][col - d].color != color {
                        reverseCondidats.append(self.cells[row - d][col - d])
                    } else {
                        reverseCondidats.append(self.cells[row - d][col - d])
                        break
                    }
                } else {
                    break
                }
            }
        }
        reverse(reverseCondidats: &reverseCondidats, color: color)

        // Main
        for d in 1..<Board.SIZE {
            if row - d < Board.SIZE && row - d >= 0 && col + d < Board.SIZE
                && col + d >= 0
            {
                if self.cells[row - d][col + d].color != "0" {
                    if self.cells[row - d][col + d].color != color {
                        reverseCondidats.append(self.cells[row - d][col + d])
                    } else {
                        reverseCondidats.append(self.cells[row - d][col + d])
                        break
                    }
                } else {
                    break
                }
            }
        }
        reverse(reverseCondidats: &reverseCondidats, color: color)

        for d in 1..<Board.SIZE {
            if row + d < Board.SIZE && row + d >= 0 && col - d < Board.SIZE
                && col - d >= 0
            {
                if self.cells[row + d][col - d].color != "0" {
                    if self.cells[row + d][col - d].color != color {
                        reverseCondidats.append(self.cells[row + d][col - d])
                    } else {
                        reverseCondidats.append(self.cells[row + d][col - d])
                        break
                    }
                } else {
                    break
                }
            }
        }
        reverse(reverseCondidats: &reverseCondidats, color: color)

    }
}
