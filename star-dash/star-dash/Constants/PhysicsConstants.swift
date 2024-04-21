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
        static let powerUpBox: UInt32 = 0b1 << 4
        static let monsterWall: UInt32 = 0b1 << 5
        static let floor: UInt32 = 0b1 << 6
        static let hook: UInt32 = 0b1 << 7
        static let homingMissile: UInt32 = 0b1 << 8
        static let boundary: UInt32 = 0b1 << 9
    }

    struct CollisionMask {
        static let player = CollisionCategory.max
        ^ CollisionCategory.player
        ^ CollisionCategory.collectible
        ^ CollisionCategory.hook
        ^ CollisionCategory.powerUpBox
        ^ CollisionCategory.homingMissile
        ^ CollisionCategory.monsterWall
        static let monster = CollisionCategory.player
        | CollisionCategory.floor
        | CollisionCategory.obstacle
        | CollisionCategory.monsterWall
        static let collectible = CollisionCategory.none
        static let obstacle = CollisionCategory.player | CollisionCategory.monster
        static let powerUpBox = CollisionCategory.none
        static let monsterWall = CollisionCategory.monster
        static let floor = CollisionCategory.player | CollisionCategory.monster
        static let hook = CollisionCategory.max
        ^ CollisionCategory.collectible
        ^ CollisionCategory.powerUpBox
        ^ CollisionCategory.player
        ^ CollisionCategory.hook
        static let homingMissile = CollisionCategory.none
        static let boundary = CollisionCategory.monster
    }

    struct ContactMask {
        static let player = CollisionCategory.floor | CollisionCategory.collectible | CollisionCategory.powerUpBox |
        CollisionCategory.homingMissile | CollisionCategory.monster
        static let monster = CollisionCategory.player
        | CollisionCategory.floor
        | CollisionCategory.obstacle
        | CollisionCategory.monsterWall
        static let collectible = CollisionCategory.player
        static let obstacle = CollisionCategory.homingMissile
        static let powerUpBox = CollisionCategory.player
        static let monsterWall = CollisionCategory.monster
        static let floor = CollisionCategory.player | CollisionCategory.homingMissile
        static let hook = CollisionCategory.obstacle
        static let homingMissile = CollisionCategory.player | CollisionCategory.obstacle | CollisionMask.floor
        static let boundary = CollisionCategory.monster
    }

    struct Dimensions {
        static let player = CGSize(width: 70, height: 110)
        static let monster = CGSize(width: 100, height: 140)
        static let collectible = CGSize(width: 60, height: 60)
        static let obstacle = CGSize(width: 60, height: 60)
        static let powerUpBox = CGSize(width: 60, height: 60)
        static let hook = CGSize(width: 20, height: 20)
        static let homingMissile = CGSize(width: 50, height: 100)
        static let flag = CGSize(width: 110, height: 100)
        static let plane = CGSize(width: 110, height: 70)
    }

    struct Mass {
        static let player = CGFloat(50)
    }

    static let jumpImpulse = CGVector(dx: 0, dy: 8_500)
    static let runSpeed: CGFloat = 20
    static let maxPlayerRunSpeed: CGFloat = 250
    static let maxMonsterRunSpeed: CGFloat = 100
    static let impulseHookReleaseX: CGFloat = 3_000
    static let impulseHookReleaseY: CGFloat = 20_000

    struct Monster {
        static let moveSpeed: Double = 100
    }
}
