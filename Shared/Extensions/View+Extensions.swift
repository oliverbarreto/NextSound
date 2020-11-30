//
//  View+Extensions.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 21/11/20.
//

import SwiftUI

extension View {
    
    func newGlow(color: Color = .white, radius: CGFloat = 20) -> some View {
        self
            .overlay(self.blur(radius: radius / 6))
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
    
    func glow() -> some View {
        self.modifier(ColorCellGlowViewModifier())
    }
    
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
    
}


extension View {
    
    func animatableFont(name: String, size: CGFloat) -> some View {
        self.modifier(AnimatableFontModifier(name: name, size: size))
    }
   
    func animatableSystemFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableSystemFontModifier(size: size, weight: weight, design: design))
    }
}
