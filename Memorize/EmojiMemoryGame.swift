//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rahul Bir on 5/12/22.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private var model: MemoryGame<String>
    
    var theme: Theme {
        didSet {
            if theme != oldValue {
                createNewGame()
            }
        }
    }
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.pairsOfCards) { pairIndex in
            theme.emojiSet[pairIndex]
        }
    }
    
    init(theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    var themeColor: LinearGradient {
        return LinearGradient(topToBottomLinearGradient: theme.fill)
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func createNewGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
