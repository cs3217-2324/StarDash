import SDPhysicsEngine

class RenderSyncronizer() {

    var entityManager: EntityManager

    var entitiesMap: [Entity: SDObject]
    var modules: [SyncModule]
    var creationModule: CreationModule?

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        modules = []
        entitiesMap = [:]

        registerModules()
    }

    func sync() {
        var toRemove = Set(entitiesMap.keys)
        
        for entity in entityManager.entitiesMap.values {
            toRemove.remove(entity)
            if let object = entitiesMap[entity] {
                update(object: object, from: entity)
            } else {
                createObject(from: entity)
            }
        }

        for entity in toRemove {
            removeObject(from: entity)
        }
    }

    func registerModule(module: SyncModule) {
        modules.append(module)
    }

    private func registerModules() {
        let spriteModule = SpriteModule(entityManager: entityManager)
        self.creationModule = spriteModule

        registerModule(spriteModule)
        registerModule(ObjectModule(entityManager: entityManager))
        registerModule(PhysicsModule(entityManager: entityManager))
    }

    private func update(object: SDObject, from entity: Entity) {
        modules.forEach {
            $0.sync(entity: entity, into: object)
        }
    }

    private func createObject(from entity: Entity) {
        guard let newObject = creationModule?.createObject(from: entity) else {
            return
        }

        module.forEach {
            $0.create(for: newObject, from: entity)
        }
    }

    private func removeObject(from entity: Entity) {
        module.forEach {
            $0.remove(entity: entity)
        }
    }
}
