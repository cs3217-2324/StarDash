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

    func separates(from collidable: Collidable) -> Event?
    func separatesFromPlayer(_ player: Player) -> Event?
    func separatesFromMonster(_ monster: Monster) -> Event?
    func separatesFromCollectible(_ collectible: Collectible) -> Event?
    func separatesFromObstacle(_ obstacle: Obstacle) -> Event?
    func separatesFromTool(_ tool: Tool) -> Event?
    func separatesFromWall(_ wall: Wall) -> Event?
    func separatesFromFloor(_ floor: Floor) -> Event?
}
