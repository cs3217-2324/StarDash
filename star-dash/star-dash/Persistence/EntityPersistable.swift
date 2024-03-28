//
//  EntityPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 21/3/24.
//

import Foundation

protocol EntityPersistable: Codable {
    func addTo(_ entityManager: EntityManagerInterface)
}
