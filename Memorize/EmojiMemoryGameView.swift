//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Rahul Bir
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Text(game.theme.name)
                    Spacer()
                    Text(String(game.score))
                }
                gameBody
                Spacer()
            }
            .padding(.horizontal)
            .font(.largeTitle)
            
            VStack {
                deckBody
                newGame
            }
        }
    }
    
    @State private var dealt = Set<String>()

    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.description.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                // Color can be used as a view and in this case it creates a clear rectangle
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                // By adding the padding here, the padding method takes away space needed for padding from the space offered by the width calculator function in AspectVGrid struct and hands over the leftover space to the CardView
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        // We need to do this because before the card views did not appear or disappear from a container that was already on screen, the AspectVGrid appeared with the cards already on there so first we need to make sure the AspectVGrid has appeared
        .foregroundStyle(game.themeColor)
    }
    
    private var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundStyle(game.themeColor)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    private var newGame: some View {
        Button {
            // All view modifiers that can be animated are being animated including the ones that LazyVGrid uses to position the cards
            withAnimation {
                dealt = []
                game.createNewGame()
            }
        } label: {
            Text("New Game").font(.body)
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
//                Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 20))
//                    .padding(5).opacity(0.5)
                Text(card.content) 
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                // Apple deprecated the other animation used in the lecture and now this works because swift ONLY animates things that change in value, NOT everything
//                    .animation(Animation.linear(duration: 6), value: card.isMatched)
                    .animation(Animation.linear(duration: 6).repeatForever(autoreverses: false), value: card.isMatched)
                // .font does NOT know how to animate, so by setting a constant to the font, no animation has to occur there
                    .font(Font.system(size: DrawingConstants.fontSize))
                // However, the scale effect CAN animate so the whole text is animatable, scales the text not really changing the font
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.60
        static let fontSize: CGFloat = 32
    }
}



























//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = EmojiMemoryGame()
//        return EmojiMemoryGameView(game: game)
//            .previewDevice("iPhone 13 Pro Max")
//            .preferredColorScheme(.dark)
//    }
//}
