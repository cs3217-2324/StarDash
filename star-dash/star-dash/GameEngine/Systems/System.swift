//
//  System.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/3/24.
//

import Foundation

protocol System: EventListener {
    var isActive: Bool { get set }
    var dispatcher: EventModifiable? { get set }
    var entityManager: EntityManager { get set }

    func update(by deltaTime: TimeInterval)
}

extension System {
    func update(by deltaTime: TimeInterval) {}
}
