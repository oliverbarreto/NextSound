//
//  ContentView.swift
//  Shared
//
//  Created by David Oliver Barreto Rodríguez on 20/11/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var gameBrain = GameBrain()
    @StateObject var settings = SettingsModel()

    
    var body: some View {
//      TestView()
        MainScreenView()
            .environmentObject(gameBrain)
            .environmentObject(settings)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
