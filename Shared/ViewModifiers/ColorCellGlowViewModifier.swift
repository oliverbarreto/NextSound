//
//  ColorCellGlowViewModifier.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 21/11/20.
//

import SwiftUI

struct ColorCellGlowViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        
        return content
            .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            .blur(radius: 15)
            .foregroundColor(.white)
    }
}
