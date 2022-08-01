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
    
    var cardsAtBeginningOfGame: [Card] = [Card]()
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.pairsOfCards) { pairIndex in
            theme.emojiSet[pairIndex]
        }
    }
    
    init(theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        cardsAtBeginningOfGame = model.cards
    }
    
    var cards: [Card] {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    var themeStyle: LinearGradient {
        return LinearGradient(topToBottomLinearGradient: theme.fill)
    }
    
    var mainColor: Color {
        return Color(rgbaColor: theme.fill.colors[0])
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func createNewGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        cardsAtBeginningOfGame = model.cards
    }
}
