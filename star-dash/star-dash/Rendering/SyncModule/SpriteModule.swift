import SDPhysicsEngine

class SpriteModule {
    let entitiesManager: EntitiesManager

    init(entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }
    
    func sync(entity: Entity, into object: SDObject) {
        guard let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
              let spriteObject = object as? SDSpriteObject else {
            return
        }

        if spriteComponent.image != spriteObject.activeTexture {
            spriteObject.runTexture(spriteComponent.image)
        }
    }

    func create(for: object: SDObject, from entity: Entity) {
        return
    }
}

extension SpriteModule: CreationModule {
    func createObject(from entity: Entity) -> SDObject? {
        var newObject = SDObject()
        if let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity) {
            newObject = SDSpriteObject()
        }

        guard let positionComponent = entityManager.component(ofType: SpriteComponent.self, of: entity) else {
            return nil
        }

        newObject.position = positionComponent.position
        newObject.rotation = positionComponent.rotation

        return newObject
    }
}
