//
//  MiniMapView.swift
//  star-dash
//
//  Created by Lau Rui han on 28/3/24.
//

import Foundation
import UIKit

class MiniMapView: UIView {
    // Player number label
    private var mapImageView: UIImageView!
    private var playerIcons: [UIImageView] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupSubviews() {
        mapImageView = UIImageView(image: #imageLiteral(resourceName: "MiniMap"))
        mapImageView.contentMode = .scaleAspectFit
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapImageView)

        NSLayoutConstraint.activate([
            mapImageView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            mapImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            mapImageView.widthAnchor.constraint(equalToConstant: 300),
            mapImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func update(playersInfo: [PlayerInfo], mapSize: CGSize) {
        removeAllPlayerIcons()

        for playerData in playersInfo {
            let playerIcon = UIImageView(image: #imageLiteral(resourceName: "RedNoseIcon"))
            playerIcon.contentMode = .scaleAspectFit
            playerIcon.translatesAutoresizingMaskIntoConstraints = false
            addSubview(playerIcon)
            playerIcons.append(playerIcon)

            let miniMapX = (playerData.position.x / mapSize.width) * mapImageView.frame.width

            playerIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
            playerIcon.centerXAnchor.constraint(equalTo: mapImageView.leadingAnchor, constant: miniMapX).isActive = true
            playerIcon.centerYAnchor.constraint(equalTo: mapImageView.bottomAnchor, constant: -20).isActive = true
        }
    }

    private func removeAllPlayerIcons() {
        for playerIcon in playerIcons {
            playerIcon.removeFromSuperview()
        }
        playerIcons.removeAll()
    }

}
