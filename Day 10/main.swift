//
//  main.swift
//  Day 10
//
//  Created by Scott Dier on 2023-12-10.
//

import Foundation

let input = """
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
""".components(separatedBy: .newlines).map({Array($0)})

enum Directions: Comparable {
    case up
    case right
    case down
    case left
}

typealias Coordinate = (x: Int, y: Int)

let pipeTypes : [Character: [Directions]] = [
    "|": [.up, .down],
    "-": [.right, .left],
    "L": [.up, .right],
    "J": [.up, .left],
    "7": [.down, .left],
    "F": [.down, .right],
    ".": [],
    "S": [.up, .right, .down, .left],
]

let fromTo : [Directions: Directions] = [
    .up: .down,
    .down: .up,
    .left: .right,
    .right: .left,
]

let directions : [Directions : Coordinate] = [
    .up : (x: 0, y:-1),
    .right : (x: 1, y:0),
    .down : (x: 0, y:1),
    .left : (x: -1, y:0)]

print(input)

var start : Coordinate? = nil
// find S
for (lineY, row) in input.enumerated() {
    var charX = row.firstIndex(of: "S")
    if charX != nil {
        start = (x: Int(charX!), y: lineY)
    }
}

if start == nil {
    fatalError("Start not found.")
}

print("start:", start!)

var curPos = start!
var lastEntry : Directions? = nil
var steps = 0

while true {
    // elgible exits, do not include entry point
    var toCheck = directions.filter({pipeTypes[input[curPos.y][curPos.x]]!.contains($0.key)})
    if lastEntry != nil {
        toCheck = toCheck.filter({$0.key != lastEntry})
    }
    var exits : [Directions: Coordinate] = [:]
    for (direction, coord) in toCheck {
        // matching entry points on nearby sq
        let checking = Coordinate(x: curPos.x + coord.x, y: curPos.y + coord.y)
        if checking.y > input.count || checking.x > input[checking.y].count || checking.y < 0 || checking.x < 0 {
            continue
        }
        if (pipeTypes[input[checking.y][checking.x]]!.contains(fromTo[direction]!)) {
            exits[direction] = checking
        }
    }
    for direction in directions.keys.sorted(by: { $0 < $1 }) {
        if exits.keys.contains(direction) {
            curPos = exits[direction]!
            lastEntry = fromTo[direction]!
        }
    }
    steps += 1
    if input[curPos.y][curPos.x] == "S" {
        break
    }
}

print(steps, steps/2, steps % 2)
