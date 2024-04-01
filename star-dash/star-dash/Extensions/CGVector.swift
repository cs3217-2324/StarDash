//
//  CGVector.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

// MARK: Operators
extension CGVector {
    var magnitude: CGFloat {
        sqrt(dx * dx + dy * dy)
    }

    static prefix func - (vector: CGVector) -> CGVector {
        CGVector(dx: -vector.dx, dy: -vector.dy)
    }

    static func + (left: CGVector, right: CGVector) -> CGVector {
        CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }

    static func - (left: CGVector, right: CGVector) -> CGVector {
        left + (-right)
    }

    static func * (left: CGVector, scalar: CGFloat) -> CGVector {
        CGVector(dx: left.dx * scalar, dy: left.dy * scalar)
    }

    static func * (scalar: CGFloat, right: CGVector) -> CGVector {
        right * scalar
    }

    static func / (left: CGVector, scalar: CGFloat) -> CGVector {
        left * (1 / scalar)
    }

    static func += (left: inout CGVector, right: CGVector) {
        left = CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }

    static func -= (left: inout CGVector, right: CGVector) {
        left = CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }

    static func *= (left: inout CGVector, scalar: CGFloat) {
        left = CGVector(dx: left.dx * scalar, dy: left.dy * scalar)
    }
}
