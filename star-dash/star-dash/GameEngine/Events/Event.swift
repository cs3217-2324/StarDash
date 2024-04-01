//
//  Event.swift
//  star-dash
//
//  Created by Jason Qiu on 13/3/24.
//

import Foundation

protocol Event {
    var playerIdForEvent: EntityId? { get }
    var timestamp: Date { get }
}
