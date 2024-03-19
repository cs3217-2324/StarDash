class PlayerComponent: Component {

    let playerIndex: Int
    var isJumping: Bool = false

    init(id: ComponentId, entityId: EntityId, playerIndex: Int) {
        super.init(id: id, entityId: entityId, playerIndex: playerIndex)
    }

    convenience init(entityId: EntityId, playerIndex: Int) {
        self.playerIndex = playerIndex
        self.init(id: UUID(), entityId: entityId)
    }
}
