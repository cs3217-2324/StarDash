import CoreGraphics

extension HomingMissile: Collidable {
    func collides(with collidable: Collidable, at contactPoint: CGPoint) -> Event? {
        collidable.collideWithHomingMissile(self, at: contactPoint)
    }

    func collideWithPlayer(_ player: Player, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: player, homingMissile: self)
    }

    func collideWithMonster(_ monster: Monster, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithCollectible(_ collectible: Collectible, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(homingMissile: self, obstacle: obstacle)
    }

    func collideWithWall(_ wall: Wall, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithFloor(_ floor: Floor, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(homingMissile: self, floor: floor)
    }

    func collideWithPowerUpBox(_ powerUpBox: PowerUpBox, at contactPoint: CGPoint) -> Event? {
        nil
    }
    
    func collideWithHomingMissile(_ homingMissile: HomingMissile, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithGrappleHook(_ grappleHook: GrappleHook, at contactPoint: CGPoint) -> Event? {
        nil
    }
}
