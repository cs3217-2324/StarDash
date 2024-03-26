class LayoutUtils {
    
    static func layoutViews(superview: UIView, for numberOfPlayers: Int) -> [PlayerViewLayout]? {
        let layouts: [Int: (UIView) -> [PlayerViewLayout]] = [
            1: createLayoutForSinglePlayer
        ]

        guard let layoutMethod = layouts[numberOfPlayers]? else {
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
        
        // Add constraints to place them side by side
        player1View.translatesAutoresizingMaskIntoConstraints = false
        player2View.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            player1View.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            player1View.topAnchor.constraint(equalTo: superview.topAnchor),
            player1View.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            player1View.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            player2View.leadingAnchor.constraint(equalTo: user1View.trailingAnchor),
            player2View.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            player2View.topAnchor.constraint(equalTo: parentView.topAnchor),
            player2View.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])

        return [
            PlayerViewLayout(superview: player1View, rotation: 0),
            PlayerViewLayout(superview: player2View, rotation: 0)
        ]
    }
}