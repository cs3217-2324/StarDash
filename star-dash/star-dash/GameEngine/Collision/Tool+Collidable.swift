//
//  Tool+Collidable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

extension Tool: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collideWithTool(self)
    }

    func collideWithPlayer(_ player: Player) -> Event? {
        CollisionHandler.between(player: player, tool: self)
    }

    func collideWithMonster(_ monster: Monster) -> Event? {
        CollisionHandler.between(monster: monster, tool: self)
    }

    func collideWithCollectible(_ collectible: Collectible) -> Event? {
        nil
    }

    func collideWithObstacle(_ obstacle: Obstacle) -> Event? {
        CollisionHandler.between(tool: self, obstacle: obstacle)
    }

    func collideWithTool(_ tool: Tool) -> Event? {
        nil
    }

    func collideWithWall(_ wall: Wall) -> Event? {
        CollisionHandler.between(tool: self, wall: wall)
    }

    func collideWithFloor(_ floor: Floor) -> Event? {
        CollisionHandler.between(tool: self, floor: floor)
    }
}
