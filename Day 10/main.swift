//
//  main.swift
//  Day 10
//
//  Created by Scott Dier on 2023-12-10.
//

import Foundation

let input = """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
""".components(separatedBy: .newlines).map({Array($0)})

var inside = Array(repeating: Array(repeating: Character("."), count: input[0].count), count: input.count)

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

let insideDir : [Directions : Directions] = [
    .up: .left,
    .right: .up,
    .down: .right,
    .left: .down,
]

let directions : [Directions : Coordinate] = [
    .up : (x: 0, y:-1),
    .right : (x: 1, y:0),
    .down : (x: 0, y:1),
    .left : (x: -1, y:0)]

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
inside[curPos.y][curPos.x] = "#"

while true {
    // elgible exits, do not include entry point
    var toCheck = directions.filter({pipeTypes[input[curPos.y][curPos.x]]!.contains($0.key)})
    if lastEntry != nil {
        toCheck = toCheck.filter({$0.key != lastEntry})
    }
    for (direction, coord) in toCheck.sorted(by: {$0.key < $1.key}) {
        // matching entry points on nearby sq
        let checking = Coordinate(x: curPos.x + coord.x, y: curPos.y + coord.y)
        if checking.y < 0 || checking.x < 0 || checking.y >= input.count || checking.x >= input[checking.y].count {
            continue
        }
        if (pipeTypes[input[checking.y][checking.x]]!.contains(fromTo[direction]!)) {
            curPos = checking
            lastEntry = fromTo[direction]!
            inside[checking.y][checking.x] = input[checking.y][checking.x]
            break
        }
    }
    steps += 1
    if input[curPos.y][curPos.x] == "S" {
        break
    }
}

print(inside.reduce(into: "") {
    $0 += $1 + "\n"
})

curPos = start!
lastEntry = nil
while true {
    print(curPos)
    var toCheck = directions.filter({pipeTypes[input[curPos.y][curPos.x]]!.contains($0.key)})
    if lastEntry != nil {
        toCheck = toCheck.filter({$0.key != lastEntry})
    }
    for (direction, coord) in toCheck.sorted(by: {$0.key < $1.key}) {
        let checking = Coordinate(x: curPos.x + coord.x, y: curPos.y + coord.y)
        if checking.y < 0 || checking.x < 0 || checking.y >= input.count || checking.x >= input[checking.y].count {
            continue
        }
        if (pipeTypes[input[checking.y][checking.x]]!.contains(fromTo[direction]!)) {
            let colorDir = directions[insideDir[direction]!]
            var toColor = [Coordinate(x: curPos.x + colorDir!.x, y: curPos.y + colorDir!.y)]
            if lastEntry != nil && lastEntry != direction {
                print(lastEntry!, direction, inside[curPos.y][curPos.x], inside[checking.y][checking.x])
                let lastEntryColorDir = directions[insideDir[fromTo[lastEntry!]!]!]
                toColor.append(Coordinate(x: curPos.x + lastEntryColorDir!.x , y: curPos.y + lastEntryColorDir!.y))
                print(toColor)
            }
            curPos = checking
            lastEntry = fromTo[direction]!
            for coloring in toColor {
                if coloring.y < 0 || coloring.x < 0 || coloring.y >= input.count || coloring.x >= input[coloring.y].count {
                    continue
                }
                if inside[coloring.y][coloring.x] == "." {
                    print("color", coloring)
                    inside[coloring.y][coloring.x] = "I"
                }
            }
            break
        }
    }
    if input[curPos.y][curPos.x] == "S" {
        break
    }
}

print(inside.reduce(into: "") {
    $0 += $1 + "\n"
})

var done = false
while !done {
    done = true
    for (lineY, row) in inside.enumerated() {
        for (charX, space) in row.enumerated() {
            if space != "I" {
                continue
            }
            for coord in directions.values {
                let checking = Coordinate(x: charX+coord.x, y: lineY+coord.y)
                if checking.y < 0 || checking.x < 0 || checking.y >= input.count || checking.x >= input[checking.y].count {
                    continue
                }
                if inside[checking.y][checking.x] == "." {
                    inside[checking.y][checking.x] = "I"
                    done = false
                }
            }
        }
    }
}

print(steps, steps/2, steps % 2)
print(inside.reduce(into: "") {
    $0 += $1 + "\n"
})
print(inside.reduce(into: 0) {
    $0 += $1.reduce(into :0) {
        if $1 == "." {
            $0 += 1
        }
    }
})
print(inside.reduce(into: 0) {
    $0 += $1.reduce(into :0) {
        if $1 == "I" {
            $0 += 1
        }
    }
})

