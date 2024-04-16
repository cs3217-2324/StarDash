//
//  GameModeModifiable.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

typealias PlayerId = EntityId

protocol GameModeModifiable: EntityManagerInterface {
    func playerIds() -> [PlayerId]
    func system<T: System>(ofType type: T.Type) -> T?
}
