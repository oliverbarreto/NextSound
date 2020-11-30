//
//  Array+Extensions.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 20/11/20.
//

import Foundation

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
}
