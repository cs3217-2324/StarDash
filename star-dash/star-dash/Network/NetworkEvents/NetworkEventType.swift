//
//  NetworkEventType.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
enum NetworkEventType: String, Codable {
    case PlayerJoinRoom = "player-join-room"
    case PlayerLeaveRoom = "player-leave-room"
    case PlayerDisconnect = "player-disconnect"
    case PlayerMove = "player-move"
    case PlayerJump = "player-jump"
    case PlayerHook = "player-hook"
    case PlayerStop = "player-stop"
    case MoveToLevelSelection = "move-to-level-selection"
    case SelectLevel = "select-level"
    case Sync = "sync"
    case SelectMode = "select-mode"
}
