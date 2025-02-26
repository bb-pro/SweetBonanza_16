
import UIKit
import AVFoundation

class SoundControllerClass: NSObject {
    static let shared = SoundControllerClass()
    
    private var players: [String: AVAudioPlayer] = [:]
    
    private override init() {
        super.init()
        setupPlayers()
    }
    
    private func setupPlayers() {
        let soundVolume = getVolume(forKey: UserHavePowersManager.shared.soundVolume)
        let musicVolume = getVolume(forKey: UserHavePowersManager.shared.musicVolume)
        
        loadPlayer(name: "bgGame", type: "mp3", volume: musicVolume, loops: true)
        loadPlayer(name: "win", type: "mp3", volume: soundVolume)
        loadPlayer(name: "gameOver", type: "mp3", volume: soundVolume)
        loadPlayer(name: "bgMenu", type: "mp3", volume: musicVolume, loops: true)
    }
    
    private func loadPlayer(name: String, type: String, volume: Float, loops: Bool = false) {
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else {
            print("❌ Failed to load sound file: \(name).\(type)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            player.numberOfLoops = loops ? -1 : 0
            players[name] = player
        } catch {
            print("❌ Error initializing player for \(name): \(error)")
        }
    }
    
    private func getVolume(forKey key: String) -> Float {
        return UserDefaults.standard.value(forKey: key) as? Float ?? 0.0
    }
    
    func playBackgroundMusic() { players["bgMenu"]?.play() }
    func stopBackgroundMusic() { players["bgMenu"]?.stop() }
    func playGameBackMusic() { players["bgGame"]?.play() }
    func stopGameBackMusic() { players["bgGame"]?.stop() }
    func playLoseSound() { players["gameOver"]?.play() }
    func playWinSound() { players["win"]?.play() }
    func stopLoseSound() { players["gameOver"]?.stop() }
    func stopWinSound() { players["win"]?.stop() }
    func setMusicVolume(_ volume: Float) {
        ["bgGame", "bgMenu"].forEach { players[$0]?.volume = volume }
    }
    
    func setSoundVolume(_ volume: Float) {
        ["gameOver", "win"].forEach { players[$0]?.volume = volume }
    }
}
