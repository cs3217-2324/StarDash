//
//  Achievement.swift
//  star-dash
//
//  Created by Ho Jun Hao on 31/3/24.
//

import Foundation

protocol Achievement {
    var name: String { get }
    var description: String { get }
    var imageName: String { get }
    var playerId: Int { get }
    var progress: Double { get }
    var isUnlocked: Bool { get }

    func reset()
    func handleEvent(event: Event, saveTo: StorageManager)
}
