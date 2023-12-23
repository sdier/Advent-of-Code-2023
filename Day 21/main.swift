//
//  main.swift
//  Day 21
//
//  Created by Scott Dier on 2023-12-23.
//

import Foundation
import DequeModule

let input = """
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
""".components(separatedBy: .newlines).map({Array($0)})

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

var map = input
for (lineY, line) in input.enumerated() {
    for (rowX, char) in line.enumerated() {
        if char == "S" {
            map[lineY][rowX] = "O"
        }
    }
}

var stepsLeft = 6

while stepsLeft > 0 {
    var newmap = map
    for (lineY, line) in map.enumerated() {
        for (rowX, char) in line.enumerated() {
            if char == "O" {
                newmap[lineY][rowX] = "."
                for (_, direction) in directions {
                    let newX = rowX + direction.x
                    let newY = lineY + direction.y
                    if newX < 0 || newY < 0 || newY >= input.count || newX >= input[0].count {
                        continue
                    }
                    if (map[newY][newX] != "#") {
                        newmap[newY][newX] = "O"
                    }
                }
            }
        }
    }
    // print(newmap.reduce(into: "", { $0 += String($1) + "\n"}))
    stepsLeft -= 1
    map = newmap
}

print(map.reduce(into: 0, { $0 += $1.reduce(into: 0, {
    if $1 == "O" {
        $0 += 1
    }
})}))
