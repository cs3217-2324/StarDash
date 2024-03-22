//
//  Obstacle+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension Obstacle: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithObstacle(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        CollisionHandler.between(player: player, obstacle: self)
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        CollisionHandler.between(monster: monster, obstacle: self)
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        nil
    }

    func collideWithHook(_ hook: GrappleHook) -> Event? {
        CollisionHandler.between(hook: hook, obstacle: self)
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        nil
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        nil
    }
}
