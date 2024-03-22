//
//  Player+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension Player: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithPlayer(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        nil
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        CollisionHandler.between(player: self, monster: monster)
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        CollisionHandler.between(player: self, collectible: collectible)
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        CollisionHandler.between(player: self, obstacle: obstacle)
    }

    func collideWithHook(_ hook: GrappleHook) -> Event? {
        CollisionHandler.between(player: self, hook: hook)
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        CollisionHandler.between(player: self, wall: wall)
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        CollisionHandler.between(player: self, floor: floor)
    }
}
