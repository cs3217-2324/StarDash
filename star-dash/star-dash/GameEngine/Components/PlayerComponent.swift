import Foundation

class PlayerComponent: Component {

    let playerIndex: Int
    var isJumping: Bool = false

    init(id: ComponentId, entityId: EntityId, playerIndex: Int) {
        self.playerIndex = playerIndex
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, playerIndex: Int) {
        self.init(id: UUID(), entityId: entityId, playerIndex: playerIndex)
    }
}
