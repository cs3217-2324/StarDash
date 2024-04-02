//
//  Collectible+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

import CoreGraphics

extension Collectible: Collidable {
    func collides(with collidable: Collidable, at contactPoint: CGPoint) -> Event? {
        collidable.collideWithCollectible(self, at: contactPoint)
    }

    func collideWithPlayer(_ player: Player, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: player, collectible: self)
    }

    func collideWithMonster(_ monster: Monster, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithCollectible(_ collectible: Collectible, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithTool(_ tool: Tool, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithWall(_ wall: Wall, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithFloor(_ floor: Floor, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithGrappleHook(_ grappleHook: GrappleHook, at contactPoint: CGPoint) -> Event? {
        nil
    }

    func collideWithPowerUp(_ powerUp: PowerUp, at contactPoint: CGPoint) -> Event? {
        nil
    }
}
