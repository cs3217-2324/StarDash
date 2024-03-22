//
//  Monster+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

import CoreGraphics

extension Monster: Collidable {
    func collides(with collidable: Collidable, at contactPoint: CGPoint) -> Event? {
        collidable.collideWithMonster(self, at: contactPoint)
    }

    func collideWithPlayer(_ player: Player, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: player, monster: self)
    }

    func collideWithMonster(_ monster: Monster, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithCollectible(_ collectible: Collectible, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(monster: self, obstacle: obstacle)
    }

    func collideWithHook(_ hook: GrappleHook, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(monster: self, hook: hook)
    }

    func collideWithWall(_ wall: Wall, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(monster: self, wall: wall)
    }

    func collideWithFloor(_ floor: Floor, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(monster: self, floor: floor)
    }
}
