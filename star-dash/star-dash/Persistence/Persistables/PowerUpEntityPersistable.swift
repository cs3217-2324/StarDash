import Foundation

struct PowerUpEntityPersistable: Codable, EntityPersistable {

    var levelId: Int64
    var position: CGPoint
    var size: CGSize
    var type: String

    func addTo(_ entityManager: EntityManagerInterface) {
        EntityFactory.createAndAddPowerUp(to: entityManager, position: position, size: size, type: type)
    }
}
