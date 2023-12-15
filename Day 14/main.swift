//
//  main.swift
//  Day 14
//
//  Created by Scott Dier on 2023-12-15.
//

import Foundation

let input = """
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
""".components(separatedBy: .newlines)

func rotate(_ note: [String]) -> [String] {
    var newNote = Array(repeating: "", count: note[0].count)
    for charIdx in 0..<note[0].count {
        for row in note {
            newNote[charIdx].append(Array(row)[charIdx])
        }
    }
    return(newNote)
}

var weight = 0
for line in rotate(input) {
    var nextCol = 0
    for (idx, char) in Array(line).enumerated() {
        switch char {
        case "O":
            weight += line.count - nextCol
            nextCol += 1
        case "#":
            nextCol = idx + 1
        case ".":
            break
        default:
            fatalError()
        }
    }
}

print(weight)
