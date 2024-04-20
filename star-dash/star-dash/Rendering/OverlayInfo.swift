import CoreGraphics
import Foundation

struct OverlayInfo {
    let score: Int
    let health: Int
    let playersInfo: [PlayerInfo]
    let mapSize: CGSize
    let time: TimeInterval
}
