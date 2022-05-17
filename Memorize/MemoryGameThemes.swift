//
//  MemoryGameThemes.swift
//  Memorize
//
//  Created by Rahul Bir on 5/16/22.
//

import Foundation

struct MemoryGameThemes {
    var name: String
    var emojiSet: [String]
    var pairsOfCards: Int
    var color: String
    
    init(name: String, emojis: [String], pairs: Int, color: String) {
        // Initialize theme name and color
        self.name = name
        self.color = color
        
        // Initialize pairs
        if pairs > emojis.count {
            pairsOfCards = emojis.count
        } else {
            pairsOfCards = pairs
        }
        
        // Initialize emojiSet to be used (according to num of pairs)
        emojiSet = [String]()
        let shuffledEmojis = emojis.shuffled()
        
        for i in 0..<pairsOfCards {
            print(pairs)
            print("\(name) - \(i)")
            emojiSet.append(shuffledEmojis[i])
        }
    }
}
