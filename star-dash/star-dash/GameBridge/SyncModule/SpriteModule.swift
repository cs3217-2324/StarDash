import CoreGraphics
import SDPhysicsEngine

class SpriteModule: SyncModule {
    let entityManager: EntityManager

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }

    func sync(entity: Entity, from object: SDObject) {
    }

    func sync(object: SDObject, from entity: Entity) {
        guard let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity.id),
              let spriteObject = object as? SDSpriteObject else {
            return
        }

        // if spriteComponent.image != spriteObject.activeTexture {
        //     spriteObject.runTexture(named: spriteComponent.image)
        // }
    }

    func create(for object: SDObject, from entity: Entity) {
    }
}

extension SpriteModule: CreationModule {
    func createObject(from entity: Entity) -> SDObject? {
        var newObject = SDObject()
        if let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity.id) {
            let spriteObject = SDSpriteObject(imageNamed: "PlayerRedNose")
            spriteObject.size = CGSize(width: 100, height: 140)
            newObject = spriteObject
        }

        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: entity.id) else {
            return nil
        }

        newObject.position = positionComponent.position
        newObject.rotation = CGFloat(positionComponent.rotation)

        return newObject
    }
}
