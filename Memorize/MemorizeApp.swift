//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Rahul Bir on 6/10/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame(theme: ThemeStore().themes[0])
    @StateObject var themeStore = ThemeStore()
    
    var body: some Scene {
        WindowGroup {
//            EmojiMemoryGameView(game: game)
            ThemeChooser()
                .environmentObject(themeStore)
//            ThemeEditor(theme: $theme)
        }
    }
}
