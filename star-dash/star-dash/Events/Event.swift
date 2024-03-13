//
//  Event.swift
//  star-dash
//
//  Created by Jason Qiu on 13/3/24.
//

import Foundation

protocol Event: Comparable {
    var timestamp: TimeInterval { get }
    var entityId: EntityId { get }

    func execute(on target: EventModifiable)
}
