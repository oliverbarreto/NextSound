//
//  SettingsModel.swift
//  NextSounds (iOS)
//
//  Created by David Oliver Barreto Rodríguez on 29/11/20.
//

import SwiftUI

class SettingsModel: ObservableObject {
    
    @Published var showSettings: Bool = false
    
    @AppStorage("soundEnabled") var soundEnabled: Bool = false
    @AppStorage("randomInitialMode") var randomInitialMode: Bool = true
    
}
