//
//  SettingsView.swift
//  Reversi
//
//  Created by Артемий Образцов on 18.01.2026.
//

import Foundation
import SwiftUI
internal import Combine

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    let AILevels = ["Easy", "Hard"]
    @State var startGame = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Reversi").font(.title).bold().padding(.top, 10)
                
                HStack() {
                    Toggle("AI🤖", isOn: $viewModel.AI).bold().font(.title2).padding(30)
                }.padding(.top, 30)
                if (viewModel.AI) {
                    HStack {
                        Text("AI Level:").bold().font(.title2).padding(.leading, 30)
                        Spacer()
                    }
                    Picker("AI Level", selection: $viewModel.AILevel) {
                        ForEach(AILevels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }.pickerStyle(SegmentedPickerStyle()).padding()
                    
                }
                HStack {
                    Text("Write your name:").bold().font(.title2).padding(.leading, 30)
                    Spacer()
                }
                TextField("", text: $viewModel.player1Name).font(.title3).bold().padding(30)
                if !viewModel.AI {
                    TextField("", text: $viewModel.player2Name).font(.title3).bold().padding(30)
                }
                Spacer()
                
                Button(action: {
                    if (!viewModel.player1Name.trimmingCharacters(in: .whitespaces).isEmpty) {
                        startGame.toggle()
                    }
                }, label: {
                    Text("Start Game").font(.title).bold().padding()
                }).buttonStyle(.glassProminent)
                
            }
        }
        
    }
}

#Preview {
    SettingsView()
}
