import CoreGraphics
import Foundation

struct GameInfo {
    let playerScore: Int
    let playerHealth: Int
    let playersInfo: [PlayerInfo]
    let mapSize: CGSize
    let time: TimeInterval
}
