//
//  MainScreenView.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//

internal import Combine
import Foundation
import SwiftUI

struct MainScreenView: View {
    @ObservedObject private var viewModel: MainScreenViewModel
    @State var AI: Bool

    init(AI: Bool, AILevel: String, name1: String, name2: String) {
        self.AI = AI
        self.viewModel = MainScreenViewModel(
            AI: AI,
            AILevel: AILevel,
            name1: name1,
            name2: name2
        )
    }

    var body: some View {
        VStack {
            Text("Reversi").font(.largeTitle).bold().padding(.top, 10)
            if viewModel.getError() == BoardError.EndGame {
                let players = viewModel.getPlayers()
                if players[0].getCntFigures() != players[1].getCntFigures() {
                    let winner = players[0]
                    Text("\(winner.getName()) has won🏆").font(.title).bold()
                } else {
                    Text("It's a draw🫥").font(.title).bold()
                }
            }
            List {
                ForEach(0..<2) { i in
                    let player = viewModel.getPlayers()[i]
                    let players = viewModel.getPlayers()
                    HStack {
                        if players[0].getCntFigures()
                            == players[1].getCntFigures()
                        {
                            Text("⚖️")
                        } else if i == 0 {
                            Text("🥇")
                        } else {
                            Text("🥈")
                        }
                        Text(player.getName()).font(.headline)
                        Spacer()
                        Text("\(player.getCntFigures())").font(.title3)
                            .bold()
                        Text(player.getColor() == "B" ? "◉" : "◎").font(.title2)
                    }
                }
            }.listStyle(.plain).animation(
                .spring(response: 1, dampingFraction: 0.7),
                value: viewModel.getPlayers()
            )
            HStack {
                if viewModel.getError() != nil {
                    if viewModel.getError() != BoardError.EndGame {
                        Text(
                            "Error: \(viewModel.getError()!.localizedDescription)"
                        )
                        .bold().foregroundStyle(.red).padding(.top, 20)
                    }
                }
            }
            HStack {
                Text(viewModel.getCurrentPlayer().getColor() == "B" ? "◉" : "◎")
                    .font(.title)
                    .bold()
                    .rotation3DEffect(
                        .degrees(
                            viewModel.getCurrentPlayer().getColor() == "B"
                                ? 0 : 180
                        ),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.7),
                        value: viewModel.getCurrentPlayer().getColor()
                    )
                Text("\(viewModel.getCurrentPlayerName())").bold().font(.title)
                    .rotation3DEffect(
                        .degrees(
                            viewModel.getCurrentPlayer().getColor() == "B"
                                ? 0 : 360
                        ),
                        axis: (x: 0, y: 1, z: 0)
                    ).animation(
                        .spring(response: 0.7, dampingFraction: 0.7),
                        value: viewModel.getCurrentPlayerName()
                    )
            }
            Spacer()

            BoardView(viewModel: viewModel)
        }
    }
}

#Preview {
    MainScreenView(AI: false, AILevel: "Easy", name1: "", name2: "")
}
