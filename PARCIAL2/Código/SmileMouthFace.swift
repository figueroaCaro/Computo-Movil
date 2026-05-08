//
//  SmileMouthFace.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//
import SwiftUI

struct SmileMouthShape: Shape {
    var curve: CGFloat   // -1 = triste, 0 = neutral, 1 = feliz
    
    var animatableData: CGFloat {
        get { curve }
        set { curve = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let start = CGPoint(x: rect.minX + 4, y: rect.midY)
        let end = CGPoint(x: rect.maxX - 4, y: rect.midY)
        let control = CGPoint(
            x: rect.midX,
            y: rect.midY + (curve * 18)
        )
        
        path.move(to: start)
        path.addQuadCurve(to: end, control: control)
        
        return path
    }
}
