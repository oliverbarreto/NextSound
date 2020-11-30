//
//  ColorCell.swift
//  NextSounds (iOS)
//
//  Created by David Oliver Barreto Rodríguez on 20/11/20.
//

import SwiftUI



struct ColorCell {
    let tag: Int
    let color: Color
    let sound: String
}

enum GameColor: String, CaseIterable {
    
    case red = "red"
    case blue = "blue"
    case green = "green"
    case yellow = "yellow"

    var tag: Int {
        
        switch self {
        case .red:
            return 1
        case .blue:
            return 2
        case .green:
            return 3
        case .yellow:
            return 4
        }
    }
    
    var color: Color {
        
        switch self {
        case .red:
            return Color.red
        case .blue:
            return Color.blue
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        }
    }
    
    var sound: String {
        switch self {
        case .red:
            return "simonSound1"
        case .blue:
            return "simonSound2"
        case .yellow:
            return "simonSound3"
        case .green:
            return "simonSound4"
        }
    }
    
//    static func color(for color: String) -> Color {
//        switch color {
//        case "red":
//            return Color.red
//        case "blue":
//            return Color.blue
//        case "yellow":
//            return Color.yellow
//        case "green":
//            return Color.green
//        default:
//            return Color.red
//        }
//    }
//
//    static func tag(for color: String) -> Int {
//        switch color {
//        case "red":
//            return 1
//        case "blue":
//            return 2
//        case "yellow":
//            return 3
//        case "green":
//            return 4
//        default:
//            return 1
//        }
//    }
    
}
