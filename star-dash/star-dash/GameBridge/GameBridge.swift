import SDPhysicsEngine

class GameBridge {

    var entityManager: EntitySyncInterface
    var scene: SDScene

    var entitiesMap: [EntityId: SDObject]
    var objectMap: [SDObjectId: EntityId]
    var modules: [SyncModule]
    var creationModule: CreationModule?

    init(entityManager: EntitySyncInterface, scene: SDScene) {
        self.entityManager = entityManager
        self.scene = scene
        modules = []
        entitiesMap = [:]
        objectMap = [:]

        registerModules()
    }

    func syncFromEntities() {
        var toRemove = Set(entitiesMap.keys)

        for entity in entityManager.entities {
            toRemove.remove(entity.id)
            if let object = entitiesMap[entity.id] {
                update(object: object, from: entity)
            } else {
                createObject(from: entity)
            }
        }

        for entityId in toRemove {
            removeObject(from: entityId)
        }
    }

    func syncToEntities() {
        for (entityId, object) in entitiesMap {
            if let entity = entityManager.entity(of: entityId) {
                update(entity: entity, from: object)
            }
        }
    }

    func entityId(of objectId: SDObjectId) -> EntityId? {
        objectMap[objectId]
    }

    private func registerModule(_ module: SyncModule) {
        modules.append(module)
    }

    private func registerModules() {
        let spriteModule = SpriteModule(entityManager: entityManager)
        self.creationModule = spriteModule

        registerModule(spriteModule)
        registerModule(ObjectModule(entityManager: entityManager))
        registerModule(PhysicsModule(entityManager: entityManager))
    }

    private func update(entity: Entity, from object: SDObject) {
        modules.forEach {
            $0.sync(entity: entity, from: object)
        }
    }

    private func update(object: SDObject, from entity: Entity) {
        modules.forEach {
            $0.sync(object: object, from: entity)
        }
    }

    private func createObject(from entity: Entity) {
        guard let newObject = creationModule?.createObject(from: entity) else {
            return
        }
        entitiesMap[entity.id] = newObject
        objectMap[newObject.id] = entity.id

        modules.forEach {
            $0.create(for: newObject, from: entity)
        }
        self.scene.addObject(newObject)
    }

    private func removeObject(from entityId: EntityId) {
    }
}
