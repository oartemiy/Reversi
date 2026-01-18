//
//  Player.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//

internal import Combine
import Foundation
import SwiftUI

class Player: ObservableObject {
    private var name: String
    @Published private var cntFigures: Int
    @Published private var color: Character

    init(num: Int) {
        self.name = "Player \(num)"
        self.cntFigures = 0
        self.color = (num == 0 ? "W" : "B")
    }

    func getName() -> String {
        return self.name
    }

    func getColor() -> Character {
        return self.color
    }

    func getCntFigures() -> Int {
        return self.cntFigures
    }

}
