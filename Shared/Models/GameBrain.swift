//
//  GameBrain.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 20/11/20.
//

import SwiftUI


class GameBrain: ObservableObject {
    
    enum GameStatus {
        case notPlaying
        case playing
//        case playing(gameTurn)
    }
    
    enum GameTurn {
        case computerTurn
        case playerTurn
    }
    
    // Model
    private(set) var brain: [ColorCell]
    
    @Published private(set) var gameStatusLabel: String = "Start"
    @Published private(set) var turnStatusLabel: String = "watch carefully"

    @Published private(set) var gameStatus: GameStatus {
        didSet {
            if gameStatus == GameStatus.notPlaying {
                gameStatusLabel = "Start"
            }
            if gameStatus == GameStatus.playing {
                gameStatusLabel = "Stop"
            }
        }
    }
    
    @Published private(set) var turnStatus: GameTurn {
        didSet {
            if turnStatus == GameTurn.computerTurn {
                turnStatusLabel = "watch carefully"
            }
            if turnStatus == GameTurn.playerTurn {
                turnStatusLabel = "your turn"
            }
        }
    }
    @Published var sequence: [ColorCell]    // Stores the full sequence of cells
    var sequenceIndex: Int                  // Stores a pointer to the sequence element to make glow
    @Published var sequenceCell: Int        // Stores the cell that we wanto to make glow. Needs to be restored back to 0 to quit glow effect
    
    private var timer = Timer()             // Used to automate the Sequence Glow
    @Published var score: Int = 0
    @AppStorage("maxScore") var maxScore: Int = 0
    @AppStorage("soundEnabled") var soundEnabled: Bool = false
    @AppStorage("randomInitialMode") var randomInitialMode: Bool = false
    
    // Constants
    let numberOfCellsPerStep = 1    // Number of color cells for every setep
    let maxNumberOfCellsPerStep = 5    // MAX Number of random color cells for every setep. . We are going to have a game option that enables a different, random or fixed, number of steps every time the sequence advances
    
    let timerDelay      = 1.0            // Time between every pulsation
    let glowDelay       = 0.5             // Time that glows before remove glow effect
    let gameDelay       = 1.5             // Time to allow breath between every seqeunce start.
    let gameOVerDelay   = 2.0          // Time delay for game over message
    static let colors = [Color.red, Color.blue, Color.green, Color.yellow]
    
    // Settings
//    private(set) var soundEnabled: Bool = false
    
    
    init() {
        brain = GameBrain.createGameBrain()
        gameStatus = .notPlaying
        turnStatus = .computerTurn
        sequence = [ColorCell]()
        sequenceIndex = 0
        sequenceCell = 0
    }
    
    
    //MARK: - Start/Stop Game
    func startGame() {
        gameStatus = .playing
        turnStatus = .computerTurn
        if randomInitialMode {
            //        sequence = GameBrain.createGameBrain()
            let randomNumberOfElements = Int.random(in: 1...maxNumberOfCellsPerStep)
            sequence = GameBrain.createSequence(with: randomNumberOfElements)
        } else {
            sequence = GameBrain.createSequence(with: numberOfCellsPerStep)
        }
        starTimer()
    }
    
    func stopGame() {
        turnStatus = .computerTurn
        gameStatus = .notPlaying
        stopTimer()
    }
    
    // Timer Intents
    func starTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerDelay), repeats: true) { timer in
            
            if self.gameStatus == .playing && self.turnStatus == .computerTurn {
                
                //self.glowAllButtons()
                self.glowSequence()
            }
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        sequenceIndex = 0
        sequenceCell = 0
        print("final sequenCell value: \(sequenceCell)")
    }
    
    
    // MARK: - Interaction Animations
    func restartSequence() {
        self.gameStatus = .playing
        self.turnStatus = .playerTurn
        
        self.sequenceIndex = 0
        self.sequenceCell = 0
        
        self.timer.invalidate()
    }
    
    func glowAllButtons() {
        if self.sequenceIndex == self.sequence.count {
            restartSequence()
            return
        }
        print("Sequence Color to glow: \(sequence[self.sequenceIndex])")
        self.sequenceCell = sequence[self.sequenceIndex].tag
        

        // Increase Sequence Index & Reset after small delay for glow effect to be noticeable
        self.sequenceIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + glowDelay) {
            self.sequenceCell = 0
        }
    }

    func glowSequence() {
        if self.sequenceIndex == self.sequence.count  {
            restartSequence()
            return
        }

        // Glow Color Cell
        print("Sequence Color to glow: \(sequence[self.sequenceIndex])")
        self.sequenceCell = sequence[self.sequenceIndex].tag
        
        // Play Sound
        if soundEnabled {
            SoundManager.playSound(sequence[sequenceIndex].sound)
        }

        // Increase Sequence Index & Reset after small delay for glow effect to be noticeable
        self.sequenceIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + glowDelay) {
            self.sequenceCell = 0
        }
    }
    
    
    
    // GAME BRAIN Intents
    private static func createGameBrain() -> [ColorCell] {
        var brain =  [ColorCell]()
        for (index, color) in GameBrain.colors.enumerated() {
            brain.append(ColorCell(tag: index + 1, color: color, sound: "simonSound\(index + 1)"))
        }
        return brain
    }
    
    
    public static func createSequence(with elements: Int) ->[ColorCell] {
    
        var sequence = [ColorCell]()
        var color: GameColor
        
        for _ in (1...elements) {
            color = GameColor.allCases.randomElement()!
            sequence.append(ColorCell(tag: color.tag, color: color.color, sound: color.sound))
        }
        
        return sequence
    }
    
    public func resetSequence() {
        sequence.removeAll()
    }
    
    private func saveScore() {
        score = sequence.count
        
        if score > maxScore {
            maxScore = score
        }
    }
    
    public func makeMove(tag: Int) {

        if (gameStatus == .notPlaying || turnStatus == .computerTurn) {
            return
        }
        
        // Glow button pressed by player
        sequenceCell = tag
        
        DispatchQueue.main.asyncAfter(deadline: .now() + glowDelay) {
            self.sequenceCell = 0
        }
        
        // Play Sound
        if soundEnabled {
            SoundManager.playSound(sequence[sequenceIndex].sound)
        }
        
        
        // Check Game rules
        if sequence[sequenceIndex].tag == tag {
            sequenceIndex += 1
            
            if sequenceIndex == sequence.count {
                saveScore()
                
                let color = GameColor.allCases.randomElement()!
                sequence.append(ColorCell(tag: color.tag, color: color.color,   sound: color.sound))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + gameDelay) {
                    self.sequenceIndex = 0
                    self.turnStatus = .computerTurn
                    self.starTimer()
                }
            }
            
        // The user played something different
        } else {
            self.turnStatusLabel = "Game Over !!!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + gameOVerDelay) {
                self.sequenceCell = 0
                self.gameStatus = .notPlaying
                self.turnStatus = .computerTurn
                
                self.stopGame()
            }
        }
    }
    
//    public func setSound(_ value: Bool) {
//        self.soundEnabled = value
//    }
}

