//
//  EventModifiable.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import Foundation

/// EventModifiable represents objects that can be modified by events.
protocol EventModifiable { 
    func system<T: System>(ofType type: T.Type) -> T?
}
