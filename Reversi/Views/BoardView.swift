//
//  BoardView.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//

import Foundation
import SwiftUI

struct BoardView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @ObservedObject var board: Board

    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        self.board = viewModel.getBoard()
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<Board.SIZE, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<Board.SIZE, id: \.self) { col in
                        CellView(cell: board.getCell(row: row, col: col))
                            .onTapGesture {
                                viewModel.makePlayerMove(row: row, col: col)
                            }.disabled(
                                viewModel.getError() == BoardError.EndGame || viewModel.AIMove
                            )
                    }
                }
            }
        }
    }
}

struct CellView: View {
    @ObservedObject private var cell: Cell

    init(cell: Cell) {
        self.cell = cell
    }

    var body: some View {
        ZStack {
            Rectangle().foregroundStyle(.white).frame(width: 46, height: 46)
                .border(.gray)
            ZStack {
                if cell.color == "W" {
                    Circle().foregroundStyle(.white).frame(
                        width: 30,
                        height: 30
                    ).overlay(Circle().stroke(.black, lineWidth: 3))
                } else if cell.color == "B" {
                    Circle().foregroundStyle(.black).frame(
                        width: 33,
                        height: 33
                    )
                }
            }.rotation3DEffect(
                .degrees(cell.isChanged ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            ).animation(
                .spring(response: 0.7, dampingFraction: 0.7),
                value: cell.isChanged
            )

        }
    }
}

#Preview {
    BoardView(
        viewModel: MainScreenViewModel(
            AI: false,
            AILevel: "Easy",
            name1: "",
            name2: ""
        )
    )
}
