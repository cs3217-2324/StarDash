//
//  NetworkEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
protocol NetworkEvent {
    var event: NetworkEventType {
        get
    }
    var playerIndex: Int {
        get
    }

}
