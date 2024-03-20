//
//  CollisionHandler.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

import Foundation

struct CollisionHandler {
    static func between(player: Player, monster: Monster) -> Event? {
        PlayerMonsterContactEvent(from: player.id, on: monster.id)
    }

    static func between(player: Player, collectible: Collectible) -> Event? {
        PickupCollectibleEvent(by: player.id, collectibleEntityId: collectible.id)
    }

    static func between(player: Player, obstacle: Obstacle) -> Event? {
        nil
    }

    static func between(player: Player, floor: Floor) -> Event? {
        nil
    }

    static func between(player: Player, wall: Wall) -> Event? {
        nil
    }

    static func between(player: Player, tool: Tool) -> Event? {
        nil
    }

    static func between(monster: Monster, tool: Tool) -> Event? {
        nil
    }

    static func between(monster: Monster, wall: Wall) -> Event? {
        nil
    }

    static func between(monster: Monster, floor: Floor) -> Event? {
        nil
    }

    static func between(monster: Monster, obstacle: Obstacle) -> Event? {
        nil
    }

    static func between(tool: Tool, floor: Floor) -> Event? {
        nil
    }

    static func between(tool: Tool, wall: Wall) -> Event? {
        nil
    }

    static func between(tool: Tool, obstacle: Obstacle) -> Event? {
        ToolObstacleCollisionEvent(betweenTool: tool.id, andObstacle: obstacle.id)
    }
}
