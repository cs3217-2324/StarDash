import AVFoundation
import UIKit

class SoundManager: SoundSystem {
    private static var instance: SoundManager?

    static let backgroundMusicFile = "background_music"

    static let delay = 0.1 // 0.1 seconds break between sound effect

    let soundEffects: [SoundEffect: String] = [
        SoundEffect.playerJump: "player_jump",
        SoundEffect.playerDeath: "player_death",
        SoundEffect.monsterDeath: "monster_death",
        SoundEffect.collectible: "collectible"
    ]

    var backgroundMusicPlayer: AVAudioPlayer?
    var soundEffectsPlayer: AVAudioPlayer?

    var lastEffectPlayedTime: Double = 0

    private init() {
        setupBackgroundMusicPlayer()
    }

    func startBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }

    func playSoundEffect(effect: SoundEffect) {
        guard let effectName = soundEffects[effect],
              let effectData = NSDataAsset(name: effectName)?.data,
              CACurrentMediaTime() - lastEffectPlayedTime > SoundManager.delay else {
            return
        }

        do {
            soundEffectsPlayer = try AVAudioPlayer(data: effectData, fileTypeHint: "mp3")
            soundEffectsPlayer?.numberOfLoops = 0
            soundEffectsPlayer?.volume = 0.5
            soundEffectsPlayer?.play()

            lastEffectPlayedTime = CACurrentMediaTime()
        } catch {
            soundEffectsPlayer = nil
        }

    }

    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let interruptionTypeRawValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeRawValue) else {
            return
        }

        switch interruptionType {
        case .began:
            backgroundMusicPlayer?.pause()
        case .ended:
            backgroundMusicPlayer?.play()
        @unknown default:
            return
        }
    }

    private func setupBackgroundMusicPlayer() {
        if let musicAsset = NSDataAsset(name: SoundManager.backgroundMusicFile) {
            do {
                try backgroundMusicPlayer = AVAudioPlayer(data: musicAsset.data, fileTypeHint: "mp3")
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.volume = 0.2

                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil
                )
            } catch {
                backgroundMusicPlayer = nil
            }
        }
    }

    static func getInstance() -> SoundManager {
        if let instance = SoundManager.instance {
            return instance
        } else {
            let newInstance = SoundManager()
            SoundManager.instance = newInstance
            return newInstance
        }
    }
}
