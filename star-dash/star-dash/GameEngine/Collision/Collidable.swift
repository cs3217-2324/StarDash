//
//  Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

import CoreGraphics

protocol Collidable {
    func collides(with collidable: Collidable, at contactPoint: CGPoint) -> Event?
    func collideWithPlayer(_ player: Player, at contactPoint: CGPoint) -> Event?
    func collideWithMonster(_ monster: Monster, at contactPoint: CGPoint) -> Event?
    func collideWithCollectible(_ collectible: Collectible, at contactPoint: CGPoint) -> Event?
    func collideWithObstacle(_ obstacle: Obstacle, at contactPoint: CGPoint) -> Event?
    func collideWithHook(_ hook: GrappleHook, at contactPoint: CGPoint) -> Event?
    func collideWithWall(_ wall: Wall, at contactPoint: CGPoint) -> Event?
    func collideWithFloor(_ floor: Floor, at contactPoint: CGPoint) -> Event?
}
