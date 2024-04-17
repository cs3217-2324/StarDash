//
//  ResultsDelegate.swift
//  star-dash
//
//  Created by Jason Qiu on 17/4/24.
//

protocol ResultsDelegate: AnyObject {
    var areResultsDisplayed: Bool { get }

    func displayResults(_ results: GameResults)
}
