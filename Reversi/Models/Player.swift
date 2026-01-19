//
//  Player.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//

internal import Combine
import Foundation
import SwiftUI

class Player: ObservableObject, Identifiable, Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }

    private var name: String
    let id = UUID()
    @Published private var cntFigures: Int
    @Published private var color: Character

    init(name: String, num: Int) {
        if name != "" {
            self.name = name
        } else {
            self.name = "Player \(num + 1)"
        }
        self.cntFigures = 2
        self.color = (num == 0 ? "B" : "W")
    }

    func getName() -> String {
        return self.name
    }

    func getColor() -> Character {
        return self.color
    }

    func setCntFigures(cnt: Int) {
        self.cntFigures = cnt
    }

    func getCntFigures() -> Int {
        return self.cntFigures
    }

}
