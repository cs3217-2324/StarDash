//
//  GrappleHook+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 29/3/24.
//

import Foundation

extension GrappleHook: Collidable {
    func collides(with collidable: Collidable, at contactPoint: CGPoint) -> Event? {
        collidable.collideWithGrappleHook(self, at: contactPoint)
    }
    
    func collideWithPlayer(_ player: Player, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(player: player, grappleHook: self)
    }
    
    func collideWithMonster(_ monster: Monster, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(monster: monster, grappleHook: self)
    }
    
    func collideWithCollectible(_ collectible: Collectible, at contactPoint: CGPoint) -> Event? {
        nil
    }
    
    func collideWithObstacle(_ obstacle: Obstacle, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(grappleHook: self, obstacle: obstacle)
    }
    
    func collideWithTool(_ tool: Tool, at contactPoint: CGPoint) -> Event? {
        nil
    }
    
    func collideWithGrappleHook(_ grappleHook: GrappleHook, at contactPoint: CGPoint) -> Event? {
        nil
    }
    
    func collideWithWall(_ wall: Wall, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(grappleHook: self, wall: wall)
    }
    
    func collideWithFloor(_ floor: Floor, at contactPoint: CGPoint) -> Event? {
        CollisionHandler.between(grappleHook: self, floor: floor)
    }
    
    func collideWithPowerUp(_ powerUp: PowerUp, at contactPoint: CGPoint) -> Event? {
        nil
    }
    
    func collideWithHomingMissle(_ homingMissle: HomingMissile, at contactPoint: CGPoint) -> Event? {
        nil
    }
}
