class JumpComponent: Component {
    var entityId: EntityId
    var id: ComponentId

    convenience init(entityId: EntityId) {
        self.init(id: UUID(), entityId: entityId)
    }
}