//
//  Collectible+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension Collectible: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithCollectible(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        CollisionHandler.between(player: player, collectible: self)
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        nil
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        nil
    }

    func collideWithHook(_ hook: GrappleHook) -> Event? {
        nil
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        nil
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        nil
    }
}
