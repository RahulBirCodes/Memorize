//
//  ThemeStore.swift
//  Memorize
//
//  Created by Rahul Bir on 7/23/22.
//

import SwiftUI

struct Theme: Equatable, Identifiable, Codable {
    var name: String
    var emojiSet: [String]
    var fill: TopToBottomLinearGradient
    var pairsOfCards: Int
    var id: String
    
    fileprivate init(name: String, emojis: String, fill: TopToBottomLinearGradient, pairsOfCards: Int) {
        self.name = name
        self.id = UUID().uuidString
        self.fill = fill
        self.pairsOfCards = pairsOfCards
        emojiSet = emojis.removingDuplicateCharacters.map({String($0)}).shuffled()
    }
}

class ThemeStore: ObservableObject {
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey = "EmojiMemoryGameThemes"
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func loadFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            themes = decodedThemes
            
       //     print("\(String(data: jsonData, encoding: .utf8) ?? "nil")")
        }
    }

    init() {
        loadFromUserDefaults()
        if themes.isEmpty {
            //  Load default themes
            insertTheme(name: "Vehicles",
                        emojis: "🚀🛸🚁🛶⛵️🚢🚗🏎🚛🚲🛴🚟🚊🛫🛬🛩🛰🚞🚄🚅🚝🚉🛳🚤",
                        fill: TopToBottomLinearGradient(colors: [Color(red: 1.0, green: 0, blue: 0)]),
                        pairsOfCards: 20)
            insertTheme(name: "Animals",
                        emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯",
                        fill: TopToBottomLinearGradient(colors: [Color(red: 0, green: 0, blue: 1)]),
                        pairsOfCards: 10)
            insertTheme(name: "Tech",
                        emojis: "⌚️📱💻⌨️🖥🖨🖱",
                        fill: TopToBottomLinearGradient(colors: [Color(red: 0.4, green: 0.4, blue: 0.4)]),
                        pairsOfCards: 7)
            insertTheme(name: "Weather",
                        emojis: "☀️🌤⛅️☁️🌦🌧⛈🌩🌨",
                        fill: TopToBottomLinearGradient(colors: [Color(red: 0.38, green: 0.64, blue: 0.84, opacity: 1.0),
                                                                           Color(red: 1.0, green: 0.52, blue: 0.69, opacity: 1.0)]),
                        pairsOfCards: 8)
            insertTheme(name: "Sports",
                        emojis: "⚽️🏀🏈⚾️🥎🎾🏐🏉🥏🎱",
                        fill: TopToBottomLinearGradient(colors: [Color(red: 0.96, green: 0.47, blue: 0.12, opacity: 1.0),
                                                                  Color(red: 0.40, green: 0.60, blue: 0.60, opacity: 1.0)]),
                        pairsOfCards: 6)
            insertTheme(name: "Fruits",
                        emojis: "🍏🍐🍊🍋🍌🍉🍇🍓🫐🍈🍒🍑🥭🍍🥥🥝",
                        fill: TopToBottomLinearGradient(colors: [Color(red: 0.42, green: 0.90, blue: 0.52, opacity: 1.0),
                                                                           Color(red: 0.87, green: 0.24, blue: 0.33, opacity: 1.0)]),
                        pairsOfCards: 12)
        }
    }
    
    static func mainColor(for theme: Theme) -> Color {
        Color(rgbaColor: theme.fill.colors[0])
    }

    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    func insertTheme(name: String, emojis: String, fill: TopToBottomLinearGradient, pairsOfCards: Int, at index: Int = 0) {
        let safeIndex = min(max(index,0), themes.count)
        themes.insert(Theme(name: name, emojis: emojis, fill: fill, pairsOfCards: pairsOfCards), at: safeIndex)
    }
    
    func removeTheme(at index: Int) {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
    }
}

// Code to encode colors within model which is UI independent

struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

struct TopToBottomLinearGradient: Codable, Equatable, Hashable {
    var colors: [RGBAColor]
}

extension LinearGradient {
    init(topToBottomLinearGradient: TopToBottomLinearGradient) {
        let colors = topToBottomLinearGradient.colors.map({Color(rgbaColor: $0)})
        self.init(colors: colors, startPoint: .top, endPoint: .bottom)
    }
}

extension Color {
    init(rgbaColor rgba: RGBAColor) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension RGBAColor {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if let cgColor = color.cgColor {
            UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

extension TopToBottomLinearGradient {
    init(colors: [Color]) {
        let rgbaColors = colors.map({RGBAColor(color: $0)})
        self.colors = rgbaColors
    }
}
