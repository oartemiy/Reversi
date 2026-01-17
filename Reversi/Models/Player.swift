//
//  Player.swift
//  Reversi
//
//  Created by Артемий Образцов on 17.01.2026.
//

import Foundation
import SwiftUI
internal import Combine


class Player : ObservableObject {
    private var name: String
    @Published private var score: Int
    @Published private var color: Character
    
    init(num: Int) {
        self.name = "Player \(num)"
        self.score = 0
        self.color = (num == 0 ? "W" : "B")
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getScore() -> Int {
        return self.score
    }
    
    func getColor() -> Character {
        return self.color
    }
    
    
}
