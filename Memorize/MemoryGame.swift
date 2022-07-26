//
//  MemoryGame.swift
//  Memorize
//
//  Created by Rahul Bir on 4/13/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private(set) var score: Int
    private var seenCards: Array<Card>
     
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } } 
    }
    
    private var startTime: Date?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
                    var extraPoints = 0
                    if let startTime = startTime {
                        extraPoints = 4 - Int(Date().timeIntervalSince(startTime)) > 0 ? 4 - Int(Date().timeIntervalSince(startTime)) : 0
                    }
                    score += 2 + extraPoints
                } else {
                    if seenCards.firstIndex(where: { $0.id == card.id }) != nil || seenCards.firstIndex(where: { $0.id == cards[potentialMatchIndex].id }) != nil {
                        score -= 1
                    } else {
                        seenCards.append(cards[chosenIndex])
                        seenCards.append(cards[potentialMatchIndex])
                    }
                }
                cards[chosenIndex].isFaceUp = true
                startTime = nil
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                startTime = Date()
            }
        }
    }
    
    mutating func newCardDeck(pairs: Int, content: (Int) -> CardContent) {
        self = MemoryGame(numberOfPairsOfCards: pairs, createCardContent: content)
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        seenCards = []
        score = 0
        
        // add number of PairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: UUID().uuidString))
            cards.append(Card(content: content, id: UUID().uuidString))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: String
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
