//
//  Logger.swift
//  star-dash
//
//  Created by Lau Rui han on 5/4/24.
//

import Foundation
import os.log

enum LogLevel {
    case info
    case debug
    case error

    var osLogType: OSLogType {
        switch self {
        case .info:
            return .info
        case .debug:
            return .debug
        case .error:
            return .error
        }
    }
}

struct Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.example"
    private static let eventCategory = "Event"
    private static let achievementCategory = "Achievement"

    static func logEvent(subtitle: String, message: String, level: LogLevel = .info) {
        let log = OSLog(subsystem: subsystem, category: eventCategory)
        logMessage(log: log, subtitle: subtitle, message: message, level: level)
    }

    static func logAchievement(subtitle: String, message: String, level: LogLevel = .info) {
        let log = OSLog(subsystem: subsystem, category: achievementCategory)
        logMessage(log: log, subtitle: subtitle, message: message, level: level)
    }

    private static func logMessage(log: OSLog, subtitle: String, message: String, level: LogLevel) {
        os_log("[%{public}@] %{public}@: %{public}@",
               log: log,
               type: level.osLogType,
               subtitle,
               level.description,
               message)
    }
}

extension LogLevel {
    var description: String {
        switch self {
        case .info:
            return "INFO"
        case .debug:
            return "DEBUG"
        case .error:
            return "ERROR"
        }
    }
}
