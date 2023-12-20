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
    "0" : .right,
    "1" : .down,
    "2" : .left,
    "3" : .up
    ]


var map : [Int: [Int: (from: Directions, to: Directions?)]] = [:]
var pos : Coordinate = (0,0)
var firstDir : Directions? = nil

for instruction in input {
    var hex = instruction[2].trimmingCharacters(in: CharacterSet(["(", ")", "#"]))
    let dir = cmd2dir[String(hex.popLast()!)]!
    let c = directions[dir]!
    let num = Int(hex, radix: 16)!
    print(num, hex)

    // for right/left only write last entry and first to
    for _ in 0..<num {
        if map.keys.contains(pos.y) && map[pos.y]!.keys.contains(pos.x) {
            if (dir == .left || dir == .right) && map[pos.y]![pos.x]!.to == dir {
                map[pos.y]!.removeValue(forKey: pos.x)
            } else {
                map[pos.y]![pos.x]!.to = dir
            }
        }
        pos = (x: pos.x + c.x, y: pos.y + c.y)
        map[pos.y, default: [:]][pos.x] = (from: dir, to: nil)
    }
}

map[0]![0]!.to = cmd2dir[String(input[0][2].trimmingCharacters(in: CharacterSet(["(", ")", "#"])).last!)]!

var contains = 0
for i in map.keys.sorted() {
    let line = map[i]!
    var inside = false
    var lineTotal = 0
    var lastToggle : Int? = nil
    for seg in line.sorted(by: {$0.key < $1.key}) {
        // convert to work on elements rather than from min to max
        // keep last inside toggle #
        // add difference when toggle off or at end
        let from = seg.value.from
        let to = seg.value.to
        let same = (from == to)
        if same {
            if from == .up || from == .down {
                if inside {
                    lineTotal += seg.key - lastToggle! - 1
                }
                inside.toggle()
                lastToggle = seg.key
            }
        }
        else {
            if((from == .right && to == .up) ||
               (from == .down && to == .right) ||
               (from == .up && to == .left) ||
               (from == .left && to == .down)) {
                if inside {
                    lineTotal += seg.key - lastToggle! - 1
                }
                inside.toggle()
                lastToggle = seg.key
            }
        }
    }
    contains += lineTotal
}

print(map.reduce(into: 0, {$0 += $1.value.count}))
print(map.reduce(into: 0, {$0 += $1.value.count}) + contains)
