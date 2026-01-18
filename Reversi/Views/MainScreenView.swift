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
    @StateObject private var viewModel = MainScreenViewModel(AI: false)

    var body: some View {
        VStack {
            Text("Reversi").font(.largeTitle).bold().padding(.top, 10)
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
                        Text("\(player.getCntFigures())").font(.subheadline)
                            .bold()
                    }
                }
            }.listStyle(.plain).animation(
                .spring(response: 1, dampingFraction: 0.7),
                value: viewModel.getPlayers()
            )
            HStack {
                if viewModel.getError() != nil {
                    
                    Text("Error: \(viewModel.getError()!.localizedDescription)")
                        .bold().foregroundStyle(.red).padding(.top, 20)
                }
            }
            HStack {
                Text(viewModel.getCurrentPlayer().getColor() == "B" ? "◉" : "◎")
                    .font(.title)
                    .bold()
                    .rotation3DEffect(
                        .degrees(
                            viewModel.getCurrentPlayer().getColor() == "B"
                                ? 0 : 360
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
    MainScreenView()
}
