// test.swift — Verify: swift-mode, 4-space indent, no tabs
import Foundation

struct Point {
    let x: Double
    let y: Double

    func distance(to other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return (dx * dx + dy * dy).squareRoot()
    }
}

enum Direction: String {
    case north, south, east, west
}

func describe(_ point: Point, heading: Direction) -> String {
    return "(\(point.x), \(point.y)) heading \(heading.rawValue)"
}

let origin = Point(x: 0, y: 0)
let target = Point(x: 3, y: 4)
print("Distance: \(origin.distance(to: target))")
print(describe(target, heading: .north))
