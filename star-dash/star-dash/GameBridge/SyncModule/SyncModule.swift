import SDPhysicsEngine

protocol SyncModule {

    func sync(entity: Entity, from object: SDObject)
    func sync(object: SDObject, from entity: Entity)
    func create(for object: SDObject, from entity: Entity)
}
