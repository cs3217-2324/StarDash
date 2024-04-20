//
//  FinishEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 20/4/24.
//

import Foundation

class FinishEvent: Event {
    let results: GameResults

    init(results: GameResults, timestamp: Date) {
        self.results = results
        super.init(timestamp: timestamp)
    }
    convenience init(results: GameResults) {
        self.init(results: results, timestamp: Date.now)
    }

}
