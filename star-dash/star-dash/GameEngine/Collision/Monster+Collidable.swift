//
//  Monster+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension Monster: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithMonster(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        CollisionHandler.between(player: player, monster: self)
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        nil
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        CollisionHandler.between(monster: self, obstacle: obstacle)
    }

    func collideWithHook(_ hook: GrappleHook) -> Event? {
        CollisionHandler.between(monster: self, hook: hook)
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        CollisionHandler.between(monster: self, wall: wall)
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        CollisionHandler.between(monster: self, floor: floor)
    }
}
