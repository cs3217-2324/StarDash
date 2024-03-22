//
//  GrappleHook+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension GrappleHook: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithHook(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        CollisionHandler.between(player: player, hook: self)
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        CollisionHandler.between(monster: monster, hook: self)
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        CollisionHandler.between(hook: self, obstacle: obstacle)
    }

    func collideWithHook(_ hook: GrappleHook) -> Event? {
        nil
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        CollisionHandler.between(hook: self, wall: wall)
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        CollisionHandler.between(hook: self, floor: floor)
    }
}
