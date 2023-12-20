//
//  main.swift
//  Day 18
//
//  Created by Scott Dier on 2023-12-19.
//

import Foundation

let input = """
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
""".components(separatedBy: .newlines).map({$0.components(separatedBy: .whitespaces)})

typealias Coordinate = (x: Int, y: Int)

enum Directions: Int {
    case up
    case right
    case down
    case left
}

let directions : [Directions : Coordinate] = [
    .up : (x: 0, y:-1),
    .right : (x: 1, y:0),
    .down : (x: 0, y:1),
    .left : (x: -1, y:0)]

let cmd2dir : [String: Directions] = [
    "R" : .right,
    "D" : .down,
    "L" : .left,
    "U" : .up
    ]


var map : [Int: [Int: (color: String, from: Directions, to: Directions?)]] = [:]
var pos : Coordinate = (0,0)

for instruction in input {
    let dir = cmd2dir[instruction[0]]!
    let c = directions[dir]!
    let num = Int(instruction[1])!
    let color = instruction[2].trimmingCharacters(in: CharacterSet(["(", ")"]))

    for _ in 0..<num {
        if map.keys.contains(pos.y) && map[pos.y]!.keys.contains(pos.x) {
            map[pos.y]![pos.x]!.to = dir
        }
        pos = (x: pos.x + c.x, y: pos.y + c.y)
        map[pos.y, default: [:]][pos.x] = (color, from: dir, to: nil)
    }
}

map[0]![0]!.to = cmd2dir[input[0][0]]

var contains = 0
for i in map.keys.sorted() {
    let line = map[i]!
    let min = line.keys.min()!
    let max = line.keys.max()!
    var inside = false
    var lineTotal = 0
    for j in min...max {
        if !line.keys.contains(j) {
            if inside {
                lineTotal += 1
            }
        } else {
            let from = line[j]!.from
            let to = line[j]!.to
            let same = (from == to)
            if same {
                if from == .up || from == .down {
                    inside.toggle()
                }
            }
            else {
                if((from == .right && to == .up) ||
                   (from == .down && to == .right) ||
                   (from == .up && to == .left) ||
                   (from == .left && to == .down)) {
                    inside.toggle()
                }
            }
        }
    }
    contains += lineTotal
}

print(map.reduce(into: 0, {$0 += $1.value.count}))
print(map.reduce(into: 0, {$0 += $1.value.count}) + contains)
