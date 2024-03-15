import SDPhysicsEngine

protocol SyncModule {
    
    func sync(entity: Entity, into object: SDObject)
    func create(for: object: SDObject, from entity: Entity)
}