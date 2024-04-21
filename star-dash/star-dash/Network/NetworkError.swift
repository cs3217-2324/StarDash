//
//  NetworkError.swift
//  star-dash
//
//  Created by Lau Rui han on 16/4/24.
//

import Foundation

public enum NetworkError: String, Codable, Error {
    case RoomNotFound = "room-not-found"
    case RoomIsFull = "room-full"
    case UnknownError = "unknown-error"
    case invalidURL = "invalid-url"
    case noDataReceived = "no-data-received"
}
