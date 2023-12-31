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

var increment = 1000000-1

typealias Coordinate = (x: Int, y: Int)
var galaxies : [Coordinate] = []

for (idxY, line) in input.enumerated() {
    for (idxX, char) in line.enumerated() {
        if char == "#" {
            galaxies.append((x: idxX, y: idxY))
        }
    }
}

var offset = 0

for (idx, line) in input.enumerated() {
    if line.allSatisfy({$0 == "."}) {
        // do stuff
        for (galaxyIdx, galaxy) in galaxies.enumerated().filter({$0.element.y > (idx + offset)}) {
            galaxies[galaxyIdx] = (x: galaxy.x, y: galaxy.y + increment)
        }
        offset += increment
    }
}

offset = 0
for idx in 0..<input[0].count {
    if input.reduce(into: [Character](), {
        $0.append($1[idx])
    }).allSatisfy({$0 == "."}) {
        for (galaxyIdx, galaxy) in galaxies.enumerated().filter({$0.element.x > (idx + offset)}) {
            galaxies[galaxyIdx] = (x: galaxy.x + increment, y: galaxy.y)
        }
        offset += increment
    }
}

print(galaxies)

var lengthSum = 0

for galaxy in galaxies.combinations(ofCount: 2) {
    // print(galaxy[0], galaxy[1], abs(galaxy[0].x - galaxy[1].x) + abs(galaxy[0].y - galaxy[1].y))
    lengthSum += abs(galaxy[0].x - galaxy[1].x) + abs(galaxy[0].y - galaxy[1].y)
}

print(lengthSum)
