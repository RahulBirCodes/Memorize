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
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
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
                        extraPoints = 3 - Int(Date().timeIntervalSince(startTime)) > 0 ? 3 - Int(Date().timeIntervalSince(startTime)) : 0
                    }
                    score += 2 + extraPoints
                    print(extraPoints)
                } else {
                    if seenCards.firstIndex(where: { $0.id == card.id }) != nil || seenCards.firstIndex(where: { $0.id == cards[potentialMatchIndex].id }) != nil {
                        score -= 1
                    } else {
                        seenCards.append(cards[chosenIndex])
                        seenCards.append(cards[potentialMatchIndex])
                    }
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
                startTime = nil
            } else {
                for index in cards.indices  {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                startTime = Date()
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        seenCards = Array<Card>()
        score = 0
        
        // add number of PairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
