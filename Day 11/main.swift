//
//  main.swift
//  Day 11
//
//  Created by Scott Dier on 2023-12-13.
//

import Foundation
import Algorithms

let input = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
""".components(separatedBy: .newlines).map({Array($0)})

var map = input

typealias Coordinate = (x: Int, y: Int)
var galaxies : [Coordinate] = []

var offset = 0

for (idx, line) in map.enumerated() {
    if line.allSatisfy({$0 == "."}) {
        map.insert(line, at: idx + offset)
        offset += 1
    }
}

offset = 0
for idx in 0..<map[0].count {
    if map.reduce(into: [Character](), {
        $0.append($1[idx+offset])
    }).allSatisfy({$0 == "."}) {
        for mapIdx in 0..<map.count {
            map[mapIdx].insert(".", at: idx+offset)
        }
        offset += 1
    }
}

print(map.reduce(into: "") {
    $0 += String($1) + "\n"
})

for (idxY, line) in map.enumerated() {
    for (idxX, char) in line.enumerated() {
        if char == "#" {
            galaxies.append((x: idxX, y: idxY))
        }
    }
}

print(galaxies)

var lengthSum = 0

for galaxy in galaxies.combinations(ofCount: 2) {
    // print(galaxy[0], galaxy[1], abs(galaxy[0].x - galaxy[1].x) + abs(galaxy[0].y - galaxy[1].y))
    lengthSum += abs(galaxy[0].x - galaxy[1].x) + abs(galaxy[0].y - galaxy[1].y)
}

print(lengthSum)
