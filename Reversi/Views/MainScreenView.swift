//
//  MainScreenView.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//

import Foundation
import SwiftUI
internal import Combine

struct MainScreenView : View {
    @StateObject private var viewModel = MainScreenViewModel(AI: false)
    
    var body: some View {
        if (viewModel.getError() != nil) {
            Text("Error: \(viewModel.getError()!.localizedDescription)").bold().foregroundStyle(.red).padding(.top, 20)
        }
        Spacer()
        BoardView(viewModel: viewModel)
        Spacer()
    }
}


#Preview {
    MainScreenView()
}
