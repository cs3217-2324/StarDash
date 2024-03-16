protocol EntitySyncInterface {

    var entities: [Entity] { get }

    func component<T: Component>(ofType type: T.Type, of entityId: EntityId) -> T?
}