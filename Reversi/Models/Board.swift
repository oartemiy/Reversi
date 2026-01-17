//
//  Board.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//

import Foundation
import SwiftUI
internal import Combine

class Cell : ObservableObject {
    var x, y : Int
    @Published var color : Character
    
    init() {
        self.x = 0
        self.y = 0
        self.color = "0"
    }
}


class Board : ObservableObject {
    static let SIZE = 8
   
    
    @Published private var cells : [[Cell]]
    
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
    
    func getCell(row : Int, col : Int) -> Cell {
        return cells[row][col]
    }
    
    func makeMove(row: Int, col: Int, color: Character) {
        
    }
}
