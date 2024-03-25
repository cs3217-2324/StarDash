import CoreGraphics
import SDPhysicsEngine

class SpriteModule: SyncModule {
    let entityManager: EntitySyncInterface

    init(entityManager: EntitySyncInterface) {
        self.entityManager = entityManager
    }

    func sync(entity: Entity, from object: SDObject) {
    }

    func sync(object: SDObject, from entity: Entity) {
        guard let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity.id),
              let spriteObject = object as? SDSpriteObject else {
            return
        }

        if spriteComponent.textureAtlas == nil && spriteObject.activeTexture != nil {
            spriteObject.cancelTexture()
            return
        }

        guard let textureAtlas = spriteComponent.textureAtlas else {
            return // no texture to run
        }

        if let activeTexture = spriteObject.activeTexture,
            activeTexture == textureAtlas {
            return // correct texture is already running
        }

        spriteObject.cancelTexture()
        spriteObject.runTexture(named: textureAtlas)
    }

    func create(for object: SDObject, from entity: Entity) {
    }
}

extension SpriteModule: CreationModule {
    func createObject(from entity: Entity) -> SDObject? {
        var newObject = SDObject()
        if let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity.id) {
            let spriteObject = SDSpriteObject(imageNamed: spriteComponent.image)

            if let size = spriteComponent.size {
                spriteObject.size = size
            }

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
