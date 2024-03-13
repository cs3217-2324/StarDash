//
//  PhysicsConstants.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

struct PhysicsConstants {
    private struct CollisionCategory {
        static let player: UInt32 = 0b00001
        static let monster: UInt32 = 0b00010
        static let collectible: UInt32 = 0b00100
        static let obstacle: UInt32 = 0b01000
        static let tool: UInt32 = 0b10000
    }

    struct CollisionMask {
        static let playerCollisionMask = CollisionCategory.monster
            | CollisionCategory.collectible | CollisionCategory.obstacle | CollisionCategory.tool

        static let monsterCollisionMask = CollisionCategory.player | CollisionCategory.tool

        static let collectibleCollisionMask = CollisionCategory.player

        static let obstacleCollisionMask = CollisionCategory.player

        static let toolCollisionMask = CollisionCategory.player | CollisionCategory.monster
    }
}
