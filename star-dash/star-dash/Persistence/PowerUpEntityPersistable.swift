import Foundation
struct PowerUpEntityPersistable: Codable, EntityPersistable {

    var levelId: Int64
    var position: CGPoint
    var sprite: String
    var size: CGSize
    var type: String

    func toEntity() -> Entity {
        PowerUp(position: self.position, sprite: self.sprite, size: self.size, type: self.type)
    }
}
