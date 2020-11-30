//
//  MainScreenView.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 21/11/20.
//

import SwiftUI

struct MainScreenView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // Model
    @EnvironmentObject var gameBrain: GameBrain
    @EnvironmentObject var settings: SettingsModel

    @State private var selectedCell: Int? = 0
    @State private var showMaxScoreLabel: Double = 0
    @State private var animatedLabelFontSize: CGFloat = 32
    
    @AppStorage("maxScore") var maxScore: Int = 0
    
    // UI Constants
    let buttonSize: CGFloat = 150
    let vSpacing: CGFloat = 10
    let hSpacing: CGFloat = 15

    
    // Call player move in Model
    private func makeMove(cell: Int) {
        if gameBrain.gameStatus == .playing && gameBrain.turnStatus == .playerTurn && cell != 0 {
            
            gameBrain.makeMove(tag: cell)
        }
    }
    
    // Highlight cell on every timer call from model
    private func cellSelected(cell: Int) {
        print("Cell Selected: \(cell)")
            selectedCell = cell
    }

    private func animations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    //.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1)
                    .repeatForever(autoreverses: true)
                ){
                    self.animatedLabelFontSize = 44
                }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(
                Animation
                    .easeIn(duration: 1)
            ){
                self.showMaxScoreLabel = 1
            }
        }
    }
    
    // View
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#22333B")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: vSpacing) {
                    
                    VStack {
                        // Top Buttons Row
                        HStack(spacing: hSpacing) {
                            ForEach(gameBrain.brain.chunked(into: 2)[0], id: \.tag) {cell in

                                ColorCellView(cell: cell, size: buttonSize, cornerRadius: ( buttonSize/2), selected: $selectedCell)
                                    .frame(width: buttonSize, height: buttonSize)
                                    .onTapGesture(count: 1) {
                                        makeMove(cell: cell.tag)
                                    }
                            }
                        }

                        // Bottom Buttons Row
                        HStack(spacing: hSpacing) {
                            ForEach(gameBrain.brain.chunked(into: 2)[1], id: \.tag) {cell in
                                
                                ColorCellView(cell: cell, size: buttonSize, cornerRadius: ( buttonSize/2), selected: $selectedCell)
                                    .frame(width: buttonSize, height: buttonSize)
                                    .onTapGesture(count: 1) {
                                        makeMove(cell: cell.tag)
                                    }
                            }
                        }
                        
                        // Score Label
                        HStack {
                            
                            if gameBrain.gameStatus == .playing {
                                Text("Score \(gameBrain.score)")
                                    .padding(.bottom, 20)
                                    .foregroundColor(colorScheme == .dark ? .secondary : .white)
                                    .font(.title)
                                
                            }
                            if gameBrain.gameStatus == .notPlaying {
                                Text("Max Score \(maxScore)")
                                    .padding(.bottom, 20)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .opacity(showMaxScoreLabel)

                            }
                        }
                        .padding(.top, 40)
                    }
                    .padding(.top, 20.0)
                    
                    
                    Spacer()
                        .frame(minHeight: 10, maxHeight: 400)
                   
                    
                    // Play Button & mesage label when playing
                    HStack(alignment: .bottom) {
                        if gameBrain.gameStatus == .notPlaying {
                            Button(action: {
                                gameBrain.startGame()
                            }) {
                                Text(gameBrain.gameStatusLabel)
                                    .foregroundColor(.purple)
                                    .animatableSystemFont(size: animatedLabelFontSize)
                                    
                            }
                        }
                        
                        
                        if gameBrain.gameStatus == .playing {
                            VStack {
                                Text(gameBrain.turnStatusLabel)
                                    .foregroundColor(.purple)
                                    .font(.largeTitle)
                                Button(action: {
                                    gameBrain.stopGame()
                                    selectedCell = 0
                                }) {
                                    Text(gameBrain.gameStatusLabel)
                                        .foregroundColor(.purple)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "gear")
                            .foregroundColor(colorScheme == .dark ?  Color(hex: "#0A0908") : Color(hex: "#F2F4F3"))
                            .onTapGesture {
                                settings.showSettings = true
                            }

//                      NavigationLink(destination: SettingsView()) {
//                          Image(systemName: "gear")
//                                .foregroundColor(colorScheme == .dark ?   Color(hex: "#0A0908") : Color(hex: "#F2F4F3"))
//                        }

                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                }
            }
            .onChange(of: gameBrain.sequenceCell) { value in
                print(value)
                cellSelected(cell: value)
            }
            .sheet(isPresented: $settings.showSettings, content: {
                SettingsView()
            })
            
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            animations()
        }
        .onChange(of: gameBrain.gameStatusLabel) { value in
            animations()
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
            .environmentObject(GameBrain())
            .environmentObject(SettingsModel())
        
    }
}

