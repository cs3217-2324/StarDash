//
//  Entity.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation
typealias EntityId = UUID

protocol Entity {
    var id: UUID {get}
    
    func setUpAndAdd(to: EntityManager)
}
