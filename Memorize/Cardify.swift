//
//  Cardify.swift
//  Memorize
//
//  Created by Rahul Bir on 6/8/22.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    // By setting cardify as animatable it takes over the animation and tells the system the data to animate and what it will look like at each step, it doesn't do any animation it just calls the body func over and over
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            // content can't be entering and exiting the card otherwise the content can't be animated if it's off screen which is why only one card was spinning
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
