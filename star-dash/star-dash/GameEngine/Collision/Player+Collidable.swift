//
//  Player+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

import CoreGraphics

extension Player: Collidable {
    func collides(with collidable: Collidable, at contactPoint: CGPoint) -> Event? {
        collidable.collideWithPlayer(self, at: contactPoint)
    }

    func collideWithPlayer(_ player: Player, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithMonster(_ monster: Monster, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: self, monster: monster)
    }

    func collideWithCollectible(_ collectible: Collectible, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: self, collectible: collectible)
    }

    func collideWithObstacle(_ obstacle: Obstacle, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: self, obstacle: obstacle)
    }

    func collideWithTool(_ tool: Tool, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: self, tool: tool)
    }

    func collideWithWall(_ wall: Wall, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: self, wall: wall)
    }

    func collideWithFloor(_ floor: Floor, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: self, floor: floor, at: contactPoint)
    }

    func collideWithPowerUp(_ powerUp: PowerUp, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: self, powerUp: powerUp, at: contactPoint)
    }

    func collideWithHomingMissle(_ homingMissle: HomingMissile, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: self, homingMissle: homingMissle)
    }
}
