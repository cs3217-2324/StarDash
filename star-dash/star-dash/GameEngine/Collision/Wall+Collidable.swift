//
//  Wall+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension Wall: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithWall(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        CollisionHandler.between(player: player, wall: self)
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        CollisionHandler.between(monster: monster, wall: self)
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        nil
    }

    func collideWithTool(_ tool: Tool) -> Event? {
        nil
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        nil
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        nil
    }

    func separates(from collidable: Collidable) -> Event? {
        collidable.separatesFromWall(self)
    }

    func separatesFromPlayer(_ player: Player) -> Event? {
        SeparationHandler.between(player: player, wall: self)
    }

    func separatesFromMonster(_ monster: Monster) -> Event? {
        SeparationHandler.between(monster: monster, wall: self)
    }

    func separatesFromCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func separatesFromObstacle(_ obstacle: Obstacle) -> Event? {
        nil
    }

    func separatesFromTool(_ tool: Tool) -> Event? {
        nil
    }

    func separatesFromWall(_ wall: Wall) -> Event? {
        nil
    }

    func separatesFromFloor(_ floor: Floor) -> Event? {
        nil
    }
}
