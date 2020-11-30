//
//  SettingsView.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 28/11/20.
//

import SwiftUI

struct SettingsView: View {
    
    enum settingsSection: String, CaseIterable {
        case startMode  = "Start Mode"
        case sound      = "Sound"
        case timer      = "Timers"
        case gameMode   = "Game Modes"
    }
    
    let sections: [settingsSection] = settingsSection.allCases
    let gameModes   = ["Normal", "Enigma", "Reversed"]
    let timers      = ["Easy", "Hard", "Extreme"]
    let startModes  = ["Random"]
    let sounds      = ["Sound"]
    
    
    @Environment(\.presentationMode) var presentationMode

    // Model
    @EnvironmentObject var settings: SettingsModel
    
    
    var body: some View {
        
        NavigationView {
            Form {
                ForEach(settingsSection.allCases, id: \.self) { section in
                    Section(header: Text(section.rawValue)) {
                        switch section {
                        case .startMode:
                            
                            ForEach(startModes, id: \.self) { setting in
                                Toggle(isOn: $settings.randomInitialMode, label: {
                                    Text("Enable Initial Random Mode")
                                })
                                    
                            }
                                                        
                        case .sound:
                            ForEach(sounds, id: \.self) { setting in
                                
                                Toggle(isOn: $settings.soundEnabled, label: {
                                    Text("Enable Sounds")
                                })
                                
                            }
                        
                        case .timer:
                            ForEach(gameModes, id: \.self) { setting in
                                Text(setting)
                            }
                        case .gameMode:
                            ForEach(timers, id: \.self) { setting in
                                Text(setting)
                            }
                        
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(leading: Button("Cancel", action: cancel), trailing: Button("OK", action: save))
        }
        .onAppear(){
            print(settings.randomInitialMode)
            print(settings.soundEnabled)
        }

    }
    
    
    private func save() {
        // Save model - use ViewModel to dismiss without confirming
        presentationMode.wrappedValue.dismiss()

    }
    
    private func cancel() {
        presentationMode.wrappedValue.dismiss()

    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsModel())
    }
}
