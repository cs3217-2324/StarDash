//
//  System.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/3/24.
//

import Foundation

protocol System {
    var isActive: Bool { get set }
    var entityManager: EntityManager { get set }

    func update(by deltaTime: TimeInterval)
}

extension System {
    func update(by deltaTime: TimeInterval) {}
}
