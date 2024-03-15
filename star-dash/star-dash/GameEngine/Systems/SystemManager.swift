//
//  SystemManager.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/3/24.
//

import Foundation

class SystemManager {
    private var systems: [System] = []

    func add(_ system: System) {
        systems.append(system)
    }

    func update(by deltaTime: TimeInterval) {
        for system in systems where system.isActive {
            system.update(by: deltaTime)
        }
    }
    
    func system<T: System>(ofType type: T.Type) -> T? {
        systems.first(where: { $0 is T }) as? T
    }
}
