//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Rahul Bir on 6/10/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
