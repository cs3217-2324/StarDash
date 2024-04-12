//
//  JoinRoomViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
import UIKit
class FruitButton: UIButton {
    var imageName: String?
    var number: String?

}
class JoinRoomViewController: UIViewController {

    @IBOutlet private var CurrentCode: UIStackView!
    @IBOutlet private var ButtonSelection: UIStackView!

    let fruits = ["Banana", "Cherry", "Grapes", "Mango", "Strawberry", "Watermelon"]
    var selectedFruits: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtonSelection()
        setupCurrentCodeTapGesture()
        updateCurrentCodeUI()
    }

    func setupButtonSelection() {
        ButtonSelection.axis = .horizontal // Ensure horizontal layout
        ButtonSelection.alignment = .center // Center the buttons vertically
        ButtonSelection.distribution = .equalSpacing // Distribute the buttons with equal spacing
        // Set the constant spacing between buttons
        ButtonSelection.spacing = 10 // Adjust spacing as needed

        for fruit in fruits {
                let button = FruitButton(type: .custom)
            let image = UIImage(named: fruit)?.withRenderingMode(.alwaysOriginal)
                button.setImage(image, for: .normal)
                button.addTarget(self, action: #selector(fruitButtonTapped(_:)), for: .touchUpInside)
                ButtonSelection.addArrangedSubview(button)
                button.imageName = fruit
            button.number = RoomCodeConstants.fruitToNumber[fruit]
                // Set image width constraint
                let imageView = button.imageView
                imageView?.contentMode = .scaleAspectFit
                imageView?.translatesAutoresizingMaskIntoConstraints = false
                imageView?.widthAnchor.constraint(equalToConstant: 75).isActive = true // Adjust width as needed
                imageView?.heightAnchor.constraint(equalTo: imageView!.widthAnchor, multiplier: 1.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 75).isActive = true

            }
    }

    func setupCurrentCodeTapGesture() {
        for view in CurrentCode.arrangedSubviews {
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(currentCodeLabelTapped(_:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    @objc func currentCodeLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view,
              let tappedIndex = CurrentCode.arrangedSubviews.firstIndex(of: tappedView),
              tappedIndex < selectedFruits.count else { return }

        let removedFruit = selectedFruits.remove(at: tappedIndex)
        tappedView.removeFromSuperview()

        // Shift remaining fruits to the left
        updateCurrentCodeUI()

    }

    @objc func fruitButtonTapped(_ sender: FruitButton) {
        guard let imageName = sender.imageName,
              selectedFruits.count < 4 else { return }

        selectedFruits.append(imageName)
        updateCurrentCodeUI()
    }

    func updateCurrentCodeUI() {
        // Clear current code boxes
        for view in CurrentCode.arrangedSubviews {
            view.removeFromSuperview()
        }
        let emptyBoxWidth: CGFloat = 100
        let emptyBoxHeight: CGFloat = 100
        // Add selected fruits to current code boxes
        for fruit in selectedFruits {
            let containerView = UIView()
                containerView.backgroundColor = .clear
                containerView.layer.borderWidth = 2
                containerView.layer.borderColor = UIColor.black.cgColor
                containerView.layer.cornerRadius = 6
                containerView.widthAnchor.constraint(equalToConstant: emptyBoxWidth).isActive = true
                containerView.heightAnchor.constraint(equalToConstant: emptyBoxHeight).isActive = true
                containerView.isUserInteractionEnabled = true

                // Create the UIImageView and add it to the container view
                let imageView = UIImageView()
                if let image = UIImage(named: fruit) {
                    imageView.image = image
                } else {
                    // Handle case when image is not found
                }
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(imageView)

                // Apply constraints to the UIImageView to add padding
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                    imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                    imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                    imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
                ])

                // Add tap gesture recognizer to the container view
                let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                  action: #selector(currentCodeLabelTapped(_:)))
                containerView.addGestureRecognizer(tapGestureRecognizer)

                // Add the container view to the arranged subviews of CurrentCode
                CurrentCode.addArrangedSubview(containerView)
        }

        // Fill remaining code boxes with empty labels
        for _ in selectedFruits.count..<4 {
            let emptyLabel = UILabel()
            emptyLabel.text = ""
            emptyLabel.textAlignment = .center
            emptyLabel.backgroundColor = .clear
            emptyLabel.layer.borderWidth = 2
            emptyLabel.layer.borderColor = UIColor.black.cgColor
            emptyLabel.layer.cornerRadius = 6
            emptyLabel.widthAnchor.constraint(equalToConstant: emptyBoxWidth).isActive = true
            emptyLabel.heightAnchor.constraint(equalToConstant: emptyBoxHeight).isActive = true
            CurrentCode.addArrangedSubview(emptyLabel)
        }
    }
    @IBAction private func joinRoom(_ sender: Any) {
        let code = selectedFruits.map({ RoomCodeConstants.fruitToNumber[$0] ?? "0" }).joined()
        performSegue(withIdentifier: "joinRoomSegue", sender: code)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "joinRoomSegue" {
            if let destinationVC = segue.destination as? RoomJoiningViewController {
                if let data = sender as? String {
                    destinationVC.roomCode = data
                }
            }
        }
    }
}
