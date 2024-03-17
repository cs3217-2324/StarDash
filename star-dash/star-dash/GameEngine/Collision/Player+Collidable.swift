//
//  Player+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension Player: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithPlayer(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        nil
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        CollisionHandler.between(player: self, monster: monster)
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        CollisionHandler.between(player: self, collectible: collectible)
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        CollisionHandler.between(player: self, obstacle: obstacle)
    }

    func collideWithTool(_ tool: Tool) -> Event? {
        CollisionHandler.between(player: self, tool: tool)
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        CollisionHandler.between(player: self, wall: wall)
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        CollisionHandler.between(player: self, floor: floor)
    }

    func separates(from collidable: Collidable) -> Event? {
        collidable.separatesFromPlayer(self)
    }

    func separatesFromPlayer(_ player: Player) -> Event? {
        nil
    }

    func separatesFromMonster(_ monster: Monster) -> Event? {
        SeparationHandler.between(player: self, monster: monster)
    }

    func separatesFromCollectible(_ collectible: Collectible) -> Event? {
        SeparationHandler.between(player: self, collectible: collectible)
    }

    func separatesFromObstacle(_ obstacle: Obstacle) -> Event? {
        SeparationHandler.between(player: self, obstacle: obstacle)
    }

    func separatesFromTool(_ tool: Tool) -> Event? {
        SeparationHandler.between(player: self, tool: tool)
    }

    func separatesFromWall(_ wall: Wall) -> Event? {
        SeparationHandler.between(player: self, wall: wall)
    }

    func separatesFromFloor(_ floor: Floor) -> Event? {
        SeparationHandler.between(player: self, floor: floor)
    }
}
