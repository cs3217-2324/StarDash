import Foundation

class GameSoundSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    let soundSystem: SoundSystem

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
        self.soundSystem = SoundManager.getInstance()
    }

    func playSoundEffect(_ effect: SoundEffect) {
        soundSystem.playSoundEffect(effect: effect)
    }
}
