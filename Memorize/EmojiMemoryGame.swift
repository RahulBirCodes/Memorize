//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rahul Bir on 5/12/22.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
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
                                   color: "gray",
                                   randomized: true),
                  MemoryGameThemes(name: "Weather",
                                   emojis: ["☀️", "🌤", "⛅️", "☁️", "🌦", "🌧", "⛈", "🌩", "🌨"],
                                   color: "blue to pink",
                                   randomized: true),
                  MemoryGameThemes(name: "Sports",
                                   emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱"],
                                   pairs: 20,
                                   color: "orange to gray"),
                  MemoryGameThemes(name: "Fruits",
                                   emojis: ["🍏", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝"],
                                   color: "green to red",
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
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    var themeColor: LinearGradient {
        switch currentTheme.color {
        // Solid colors
        case "red":
            return LinearGradient(colors: [.red], startPoint: .top, endPoint: .bottom)
        case "blue":
            return LinearGradient(colors: [.blue], startPoint: .top, endPoint: .bottom)
        case "gray":
            return LinearGradient(colors: [.gray], startPoint: .top, endPoint: .bottom)
        case "green":
            return LinearGradient(colors: [.green], startPoint: .top, endPoint: .bottom)
        case "orange":
            return LinearGradient(colors: [.orange], startPoint: .top, endPoint: .bottom)
        case "purple":
            return LinearGradient(colors: [.purple], startPoint: .top, endPoint: .bottom)
        // Gradients
        case "blue to pink":
            return LinearGradient(colors: [Color(red: 0.38, green: 0.64, blue: 0.84, opacity: 1.0),
                                           Color(red: 1.0, green: 0.52, blue: 0.69, opacity: 1.0)],
                                  startPoint: .top,
                                  endPoint: .bottom)
        case "orange to gray":
            return LinearGradient(colors: [Color(red: 0.96, green: 0.47, blue: 0.12, opacity: 1.0),
                                           Color(red: 0.40, green: 0.60, blue: 0.60, opacity: 1.0)],
                                  startPoint: .top,
                                  endPoint: .bottom)
        case "green to red":
            return LinearGradient(colors: [Color(red: 0.42, green: 0.90, blue: 0.52, opacity: 1.0),
                                           Color(red: 0.87, green: 0.24, blue: 0.33, opacity: 1.0)],
                                  startPoint: .top,
                                  endPoint: .bottom)
        default:
            return LinearGradient(colors: [.gray], startPoint: .top, endPoint: .bottom)
        }
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func createNewRandomizedGame() {
        var newTheme = EmojiMemoryGame.themes.randomElement()!
        
        if newTheme.randomNumOfPairs != nil { newTheme.randomizePairsNum() }
        
        model.newCardDeck(pairs: newTheme.pairsOfCards) { newTheme.emojiSet[$0] }
        
//        model = MemoryGame<String>(numberOfPairsOfCards: newTheme.pairsOfCards) { pairIndex in
//            newTheme.emojiSet[pairIndex]
//        }
        currentTheme = newTheme
        
        print(cards)
    }
}
