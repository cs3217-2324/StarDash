//
//  PhysicsConstants.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

struct PhysicsConstants {
    struct CollisionCategory {
        static let none: UInt32 = 0
        static let max: UInt32 = 0xFFFFFFFF
        static let player: UInt32 = 0b1 << 0
        static let monster: UInt32 = 0b1 << 1
        static let collectible: UInt32 = 0b1 << 2
        static let obstacle: UInt32 = 0b1 << 3
        static let hook: UInt32 = 0b1 << 4
        static let wall: UInt32 = 0b1 << 5
        static let floor: UInt32 = 0b1 << 6
    }

    struct CollisionMask {
        static let player = CollisionCategory.max ^ CollisionCategory.player ^ CollisionCategory.collectible
        static let monster = CollisionCategory.player | CollisionCategory.hook
        static let collectible = CollisionCategory.none
        static let obstacle = CollisionCategory.player | CollisionCategory.monster | CollisionMask.hook
        static let hook = CollisionCategory.max ^ CollisionCategory.collectible ^ CollisionCategory.hook
        static let wall = CollisionCategory.player | CollisionCategory.monster | CollisionCategory.hook
        static let floor = CollisionCategory.player | CollisionCategory.monster | CollisionCategory.hook
    }

    struct ContactMask {
        static let player = CollisionCategory.floor | CollisionCategory.collectible
        static let monster = CollisionCategory.player
        static let collectible = CollisionCategory.player
        static let obstacle = CollisionCategory.none
        static let hook = CollisionCategory.obstacle
        static let wall = CollisionCategory.hook | CollisionCategory.player
        static let floor = CollisionCategory.player
    }

    struct Dimensions {
        // TODO: determine appropriate size for each
        static let player = CGSize(width: 60, height: 60)
        static let monster = CGSize(width: 60, height: 60)
        static let collectible = CGSize(width: 60, height: 60)
        static let obstacle = CGSize(width: 60, height: 60)
        static let wall = CGSize(width: 60, height: 60)
        static let floor = CGSize(width: 300, height: 60)
    }

    static let jumpImpulse = CGVector(dx: 0, dy: 80)
    static let runVelocity = CGVector(dx: 50, dy: 0)
}
