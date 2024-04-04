//
//  CGFloat.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

import Foundation

// MARK: Operators
extension CGFloat {
    static func + (left: CGFloat, right: Int) -> CGFloat {
        left + CGFloat(right)
    }
    
    static func + (left: Int, right: CGFloat) -> CGFloat {
        right + left
    }
    
    static func * (left: CGFloat, right: Int) -> CGFloat {
        left * CGFloat(right)
    }

    static func * (left: Int, right: CGFloat) -> CGFloat {
        right * left
    }
}
