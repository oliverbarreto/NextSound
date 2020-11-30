//
//  TestView.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 21/11/20.
//

import SwiftUI


class SequenceManager: ObservableObject {
    var timer = Timer()
    let colors = [Color.red, Color.yellow, Color.blue, Color.green, Color.orange, Color.pink]
    var sequencePointer: Int = 0
    let time = 1
    @Published var glowColor = Color.clear
    
    func starTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: true) { timer in
//            self.glowColor = self.colors.randomElement() ?? Color.black
            
            if self.sequencePointer == self.colors.count-1 {
                self.sequencePointer = 0
                
            } else {
                self.sequencePointer += 1
                self.glowColor = self.colors[self.sequencePointer]
            }
            
            
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        glowColor = .clear
        sequencePointer = 0
    }
}

struct TestView: View {
    @EnvironmentObject var gameBrain: GameBrain
//    @State var glowColor = Color.clear
    @State var isPlaying = false
    @StateObject var timer = SequenceManager()


    var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .frame(width: 150, height: 150)
                .cornerRadius(75)
                .foregroundColor(Color.purple)
                .shadow(color: timer.glowColor, radius: 20, x: 0.0, y: 0.0)
            
            Spacer()
            
            Button(action: {
                if isPlaying {
                    isPlaying = false
                    timer.stopTimer()
                } else {
                    isPlaying = true
                    timer.starTimer()
                }
            }) {
                if isPlaying {
                    Text("Stop")
                } else {
                    Text("Start")
                }
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
