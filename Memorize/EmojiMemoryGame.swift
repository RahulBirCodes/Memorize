//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rahul Bir on 5/12/22.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    
    private static var themes = [MemoryGameThemes(name: "Vehicles",
                                   emojis: ["🚀", "🛸", "🚁", "🛶", "⛵️", "🚢", "🚗", "🏎", "🚛", "🚲", "🛴", "🚟", "🚊", "🛫", "🛬", "🛩", "🛰", "🚞", "🚄", "🚅", "🚝", "🚉", "🛳", "🚤"],
                                   pairs: 8,
                                   color: "red"),
                  MemoryGameThemes(name: "Animals",
                                   emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯"],
                                   pairs: 4,
                                   color: "blue"),
                  MemoryGameThemes(name: "Tech",
                                   emojis: ["⌚️", "📱", "💻", "⌨️", "🖥", "🖨", "🖱"],
                                   color: "black",
                                   randomized: true),
                  MemoryGameThemes(name: "Weather",
                                   emojis: ["☀️", "🌤", "⛅️", "☁️", "🌦", "🌧", "⛈", "🌩", "🌨"],
                                   color: "green",
                                   randomized: true),
                  MemoryGameThemes(name: "Sports",
                                   emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱"],
                                   pairs: 20,
                                   color: "orange"),
                  MemoryGameThemes(name: "Fruits",
                                   emojis: ["🍏", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝"],
                                   color: "purple",
                                   randomized: false)]
    
//    static func createMemoryGame(theme: MemoryGameThemes) -> MemoryGame<String> {
//        MemoryGame<String>(numberOfPairsOfCards: currentTheme.pairsOfCards) { pairIndex in
//            theme.emojiSet[pairIndex]
//        }
//    }
    
    @Published private var model: MemoryGame<String>
    @Published private(set) var currentTheme: MemoryGameThemes
    
    init() {
        let newTheme = EmojiMemoryGame.themes.randomElement()!
        model = MemoryGame<String>(numberOfPairsOfCards: newTheme.pairsOfCards) { pairIndex in
            newTheme.emojiSet[pairIndex]
        }
        currentTheme = newTheme
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    var themeColor: Color {
        switch currentTheme.color {
        case "red":
            return Color.red
        case "blue":
            return Color.blue
        case "black":
            return Color.black
        case "green":
            return Color.green
        case "orange":
            return Color.orange
        case "purple":
            return Color.purple
        default:
            return Color.black
        }
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func createNewRandomizedGame() {
        var newTheme = EmojiMemoryGame.themes.randomElement()!
        
        if newTheme.randomNumOfPairs != nil { newTheme.randomizePairsNum() }
        
        model = MemoryGame<String>(numberOfPairsOfCards: newTheme.pairsOfCards) { pairIndex in
            newTheme.emojiSet[pairIndex]
        }
        currentTheme = newTheme
    }
}
