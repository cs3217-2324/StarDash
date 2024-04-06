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
        PlayerObstacleContactEvent(from: player.id, on: obstacle.id)
    }

    static func between(player: Player, floor: Floor, at contactPoint: CGPoint) -> Event? {
        PlayerFloorContactEvent(from: player.id, at: contactPoint)
    }

    static func between(player: Player, wall: Wall) -> Event? {
        nil
    }

    static func between(player: Player, grappleHook: GrappleHook) -> Event? {
        nil
    }

    static func between(monster: Monster, grappleHook: GrappleHook) -> Event? {
        ReleaseGrappleHookEvent(using: grappleHook.id)
    }

    static func between(monster: Monster, wall: Wall) -> Event? {
        nil
    }

    static func between(monster: Monster, floor: Floor) -> Event? {
        nil
    }

    static func between(monster: Monster, obstacle: Obstacle, at contactPoint: CGPoint) -> Event? {
        MonsterObstacleContactEvent(from: monster.id, on: obstacle.id, at: contactPoint)
    }

    static func between(grappleHook: GrappleHook, floor: Floor) -> Event? {
        ReleaseGrappleHookEvent(using: grappleHook.id)
    }

    static func between(grappleHook: GrappleHook, wall: Wall) -> Event? {
        ReleaseGrappleHookEvent(using: grappleHook.id)
    }

    static func between(grappleHook: GrappleHook, obstacle: Obstacle) -> Event? {
        GrappleHookObstacleContactEvent(betweenHook: grappleHook.id, andObstacle: obstacle.id)
    }

    static func between(player: Player, powerUpBox: PowerUpBox, at contactPoint: CGPoint) -> Event? {
        PowerUpBoxPlayerEvent(from: player.id, pickedUp: powerUpBox.id)
    }

    static func between(player: Player, homingMissile: HomingMissile) -> Event? {
        MissileHitPlayerEvent(from: player.id, missile: homingMissile.id)
    }

    static func between(homingMissile: HomingMissile, floor: Floor) -> Event? {
        MissileBlockedEvent(missile: homingMissile.id)
    }

    static func between(homingMissile: HomingMissile, obstacle: Obstacle) -> Event? {
        MissileBlockedEvent(missile: homingMissile.id)
    }
}
