/**
 A protocol defining methods for managing background music and sound effects.
 */
protocol SoundSystem {

    /**
     Start playing background music.
     */
    func startBackgroundMusic()

    /**
     Stop playing background music.
     */
    func stopBackgroundMusic()

    func playSoundEffect(effect: SoundEffect)
}
