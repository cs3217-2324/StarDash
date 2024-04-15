//
//  GameModeModifiable.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

protocol GameModeModifiable: EntityManagerInterface {
    func system<T: System>(ofType type: T.Type) -> T?
}
