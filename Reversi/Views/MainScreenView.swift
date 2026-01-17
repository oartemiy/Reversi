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
        BoardView(viewModel: viewModel)
    }
}


#Preview {
    MainScreenView()
}
