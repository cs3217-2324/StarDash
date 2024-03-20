//
//  Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

protocol Collidable {
    func collides(with collidable: Collidable) -> Event?
    func collideWithPlayer(_ player: Player) -> Event?
    func collideWithMonster(_ monster: Monster) -> Event?
    func collideWithCollectible(_ collectible: Collectible) -> Event?
    func collideWithObstacle(_ obstacle: Obstacle) -> Event?
    func collideWithTool(_ tool: Tool) -> Event?
    func collideWithWall(_ wall: Wall) -> Event?
    func collideWithFloor(_ floor: Floor) -> Event?
}
