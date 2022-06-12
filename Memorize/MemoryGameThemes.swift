//
//  MemoryGameThemes.swift
//  Memorize
//
//  Created by Rahul Bir on 5/16/22.
//

import Foundation

struct MemoryGameThemes {
    private(set) var name: String
    private(set) var emojiSet: [String]
    private(set) var pairsOfCards: Int
    private(set) var color: String
    private(set) var randomNumOfPairs: Bool?
    
    mutating func randomizePairsNum() {
        pairsOfCards = Int.random(in: 2...emojiSet.count)
    }
    
    init(name: String, emojis: [String], color: String, randomized: Bool) {
        var pairs = emojis.count
        if randomized {
            pairs = Int.random(in: 2...emojis.count)
        }
        self.init(name: name, emojis: emojis, pairs: pairs, color: color)
        randomNumOfPairs = randomized ? true : nil

    }
    
    init(name: String, emojis: [String], pairs: Int?, color: String) {
        // Initialize theme name and color
        self.name = name
        self.color = color
        
        // Initialize pairs
        pairsOfCards = emojis.count
        if let pairs = pairs, pairs < pairsOfCards {
            pairsOfCards = pairs
        }
        
        // Initialize emojiSet to be used (according to num of pairs)
        emojiSet = [String]()
        let shuffledEmojis = emojis.shuffled()
        
        for i in 0..<pairsOfCards {
            emojiSet.append(shuffledEmojis[i])
        }
    }
}
