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

    static func between(player: Player, floor: Floor, at contactPoint: CGPoint) -> Event? {
        PlayerFloorContactEvent(from: player.id, at: contactPoint)
    }

    static func between(player: Player, wall: Wall) -> Event? {
        nil
    }

    static func between(player: Player, hook: GrappleHook) -> Event? {
        nil
    }

    static func between(monster: Monster, hook: GrappleHook) -> Event? {
        ReleaseGrappleHookEvent(using: hook.id)
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

    static func between(hook: GrappleHook, floor: Floor) -> Event? {
        ReleaseGrappleHookEvent(using: hook.id)
    }

    static func between(hook: GrappleHook, wall: Wall) -> Event? {
        ReleaseGrappleHookEvent(using: hook.id)
    }

    static func between(hook: GrappleHook, obstacle: Obstacle) -> Event? {
        HookObstacleCollisionEvent(betweenHook: hook.id, andObstacle: obstacle.id)
    }
}
