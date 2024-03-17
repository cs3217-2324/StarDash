import SDPhysicsEngine

protocol CreationModule {
    func createObject(from entity: Entity) -> SDObject?
}
