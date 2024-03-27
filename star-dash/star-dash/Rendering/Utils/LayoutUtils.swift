import UIKit

class LayoutUtils {

    static func layoutViews(superview: UIView, for numberOfPlayers: Int) -> [PlayerViewLayout]? {
        let layouts: [Int: (UIView) -> [PlayerViewLayout]] = [
            1: createLayoutForSinglePlayer,
            2: createLayoutForTwoPlayers
        ]

        guard let layoutMethod = layouts[numberOfPlayers] else {
            return nil
        }

        return layoutMethod(superview)
    }

    static func createLayoutForSinglePlayer(superview: UIView) -> [PlayerViewLayout] {
        [PlayerViewLayout(
            superview: superview,
            rotation: 0
        )]
    }

    static func createLayoutForTwoPlayers(superview: UIView) -> [PlayerViewLayout] {
        let player1View = UIView()
        let player2View = UIView()

        superview.addSubview(player1View)
        superview.addSubview(player2View)

        player1View.frame = CGRect(x: 0, y: 0, width: superview.frame.width / 2, height: superview.frame.height)
        player2View.frame = CGRect(x: superview.frame.width / 2,
                                   y: 0,
                                   width: superview.frame.width / 2,
                                   height: superview.frame.height)

        return [
            PlayerViewLayout(superview: player1View, rotation: .pi / 2),
            PlayerViewLayout(superview: player2View, rotation: .pi * 3 / 2)
        ]
    }
}
