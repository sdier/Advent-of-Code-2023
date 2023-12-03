//
//  main.swift
//  Day 3
//
//  Created by Scott Dier on 2023-12-03.
//

import Foundation

let input = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
""".components(separatedBy: .newlines).map({Array(String($0))})

// stole from 2019 day 24
enum Directions {
    case up
    case down
    case left
    case right
    case upleft
    case upright
    case downleft
    case downright
}

typealias Coordinate = (x: Int, y: Int)

let directions : [Directions : Coordinate] = [
    .up: (x: 0, y:-1),
    .down: (x: 0, y:1),
    .left: (x: -1, y:0),
    .right: (x: 1, y:0),
    .upleft: (x: -1, y: -1),
    .upright: (x: 1, y: -1),
    .downleft: (x: -1, y: 1),
    .downright: (x: 1, y: 1),
]

var partNumTotal = 0
var gearRatios : [String: [Int]] = [:]

for (lineY, row) in input.enumerated() {
    var curNum = ""
    var symbolSeen = false
    var starCoord = ""
    for (charX, space) in row.enumerated() {
        switch space {
        case let c where c.isNumber:
            // This is a number and we should add it to curNum and check adjecent squares for symbols.
            curNum.append(c)
            for (_, coord) in directions {
                let lookX = charX + coord.x
                let lookY = lineY + coord.y
                // Don't try and look outside the map.
                if lookY < 0 || lookY >= input.count || lookX < 0 || lookX >= input[0].count {
                    continue
                }
                switch input[lookY][lookX] {
                case let c where c.isNumber || c == ".":
                    continue
                case "*":
                    starCoord = String(lookY) + "," + String(lookX)
                    fallthrough
                default:
                    symbolSeen = true
                }
            }
        default:
            // No number or the number has ended.  If a symbol was seen, add it to the total.
            if curNum == "" || !symbolSeen {
                curNum = ""
                continue
            }
            partNumTotal += Int(curNum)!
            if starCoord != "" {
                gearRatios[starCoord, default: []].append(Int(curNum)!)
            }
            curNum = ""
            starCoord = ""
            symbolSeen = false
        }
    }
    // Line ended, if a symbol was seen, add it to the total.
    if curNum == "" || !symbolSeen {
        continue
    }
    // Do this sort of tail work as a function next time, when I wrote part 2 I forgot to add the additional action.
    partNumTotal += Int(curNum)!
    if starCoord != "" {
        gearRatios[starCoord, default: []].append(Int(curNum)!)
    }
}

print(partNumTotal)

print(gearRatios.reduce(into: Int(0)) {
    if $1.value.count == 2 {
        $0 += $1.value[0] * $1.value[1]
    }
})
