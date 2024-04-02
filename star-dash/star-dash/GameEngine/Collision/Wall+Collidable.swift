//
//  Wall+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

import CoreGraphics

extension Wall: Collidable {
    func collides(with collidable: Collidable, at contactPoint: CGPoint) -> Event? {
        collidable.collideWithWall(self, at: contactPoint)
    }

    func collideWithPlayer(_ player: Player, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: player, wall: self)
    }

    func collideWithMonster(_ monster: Monster, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(monster: monster, wall: self)
    }

    func collideWithCollectible(_ collectible: Collectible, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithTool(_ tool: Tool, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(tool: tool, wall: self)
    }

    func collideWithWall(_ wall: Wall, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithFloor(_ floor: Floor, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithGrappleHook(_ grappleHook: GrappleHook, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(grappleHook: grappleHook, wall: self)
    }

    func collideWithPowerUp(_ powerUp: PowerUp, at contactPoint: CGPoint) -> Event? {
        nil
    }
}
