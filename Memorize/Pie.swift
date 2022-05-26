//
//  Pie.swift
//  Memorize
//
//  Created by Rahul Bir on 5/25/22.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    // If we set this value to a let then it would get instantly initialized and someone creating a Pie would not be able to specify the clockwise value
    var clockwise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 // Is inverted because coordinate system starts from top left corner of view NOT bottom left like usual graphs
                 clockwise: !clockwise)
        p.addLine(to: center)
        
        return p
        
    }
    
    
    
}
