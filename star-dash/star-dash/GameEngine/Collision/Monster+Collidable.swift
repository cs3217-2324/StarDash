//
//  Monster+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension Monster: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithMonster(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        CollisionHandler.between(player: player, monster: self)
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        nil
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        nil
    }

    func collideWithTool(_ tool: Tool) -> Event? {
        CollisionHandler.between(monster: self, tool: tool)
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        nil
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        nil
    }

    func separates(from collidable: Collidable) -> Event? {
        collidable.separatesFromMonster(self)
    }

    func separatesFromPlayer(_ player: Player) -> Event? {
        SeparationHandler.between(player: player, monster: self)
    }

    func separatesFromMonster(_ monster: Monster) -> Event? {
        nil
    }

    func separatesFromCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func separatesFromObstacle(_ obstacle: Obstacle) -> Event? {
        nil
    }

    func separatesFromTool(_ tool: Tool) -> Event? {
        SeparationHandler.between(monster: self, tool: tool)
    }

    func separatesFromWall(_ wall: Wall) -> Event? {
        nil
    }

    func separatesFromFloor(_ floor: Floor) -> Event? {
        nil
    }
}
