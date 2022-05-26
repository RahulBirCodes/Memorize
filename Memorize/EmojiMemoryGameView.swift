//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Rahul Bir
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
             
    var body: some View {
        VStack {
            HStack {
                Text(game.currentTheme.name)
                Spacer()
                Text(String(game.score))
            }
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
//                    ForEach(game.cards) { card in
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                CardView(card: card)
                    .padding(4)
                    // By adding the padding here, the padding method takes away space needed for padding from the space offered by the width calculator function in AspectVGrid struct and hands over the leftover space to the CardView
                    .onTapGesture {
                        game.choose(card)
                    }
            })
//                    }
//                }
//            }
            .foregroundStyle(game.themeColor)
            
            Spacer()
            newGame
        }
        .padding(.horizontal)
        .font(.largeTitle)
    }
    
    private var newGame: some View {
        Button {
            game.createNewRandomizedGame()
        } label: {
            Text("New Game")
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 20))
                        .padding(5).opacity(0.5)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.60
    }
}



























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .previewDevice("iPhone 13 Pro Max")
            .preferredColorScheme(.dark)
    }
}
