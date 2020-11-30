//
//  ColorCellView.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 20/11/20.
//

import SwiftUI

struct ColorCellView: View {
    @EnvironmentObject var gameBrain: GameBrain

    let cell: ColorCell
    let size: CGFloat
    let cornerRadius: CGFloat
    let glowRadius: CGFloat = 20
    
    @Binding var selected: Int?
    
    var body: some View {
        ZStack {
            if selected == cell.tag {
                RoundedRectangle(cornerRadius: cornerRadius )
                    .frame(width:size, height: size)
                    .foregroundColor(cell.color)
                    .if(gameBrain.gameStatus == .notPlaying) {
                        $0.allowsHitTesting(false)
                    }
                    .newGlow(color: cell.color, radius: glowRadius)
            }
            
            RoundedRectangle(cornerRadius: cornerRadius )
                .frame(width:size, height: size)
                .foregroundColor(cell.color)
        }
        
    }
}

struct ColorCellView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCellView(cell: ColorCell(tag: 1,  color: Color.blue, sound: ""), size: 200, cornerRadius: 100, selected: .constant(3))
    }
}
