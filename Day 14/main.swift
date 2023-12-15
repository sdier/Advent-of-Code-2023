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

func coltorow(_ note: [String]) -> [String] {
    var newNote = Array(repeating: "", count: note[0].count)
    for charIdx in 0..<note[0].count {
        for row in note {
            newNote[charIdx].append(Array(row)[charIdx])
        }
    }
    return newNote
}

func rotate(_ note: [String]) -> [String] {
    var newNote = Array(repeating: Array(repeating: Character(" "), count: note.count), count: note[0].count)
    for srcX in 0..<note[0].count {
        for (srcY, row) in note.enumerated() {
            // 0,0 -> 0,9
            // 1,0 -> 0,8
            // 2,0 -> 0,7
            // 0,1 -> 1,9
            newNote[srcX][newNote[srcX].count - 1 - srcY] = Array(row)[srcX]
        }
    }
    return newNote.map({$0.reduce(into: "", {$0.append($1)})})
}

var cache : [[String]: Int] = [:]
var weights : [Int] = []

var map = input
var finished : Int?
var startCycle : Int?
for i in 0..<1000000000 {
    let lastMap = map
    var weight = 0
    if cache.keys.contains(map) {
        finished = i - 1
        startCycle = cache[map]!
        break
    } else {
        for _ in 0..<4 {
            weight = 0
            let columnMap = coltorow(map)
            var newMap = Array(repeating: Array(repeating: Character("."), count: map[0].count), count: map.count)
            for (idxY, line) in columnMap.enumerated() {
                var nextCol = 0
                for (idx, char) in Array(line).enumerated() {
                    switch char {
                    case "O":
                        weight += line.count - idxY
                        newMap[nextCol][idxY] = "O"
                        nextCol += 1
                    case "#":
                        newMap[idx][idxY] = "#"
                        nextCol = idx + 1
                    case ".":
                        break
                    default:
                        fatalError()
                    }
                }
            }
            map = rotate(newMap.map({$0.reduce(into: "", {$0.append($1)})}))
        }
        // print(map.reduce(into: "", {$0.append($1 + "\n")}))
    }
    weights.append(weight)
    cache[lastMap] = i
}

let offset = (1000000000 - (startCycle! + 1)) % (finished! - startCycle! + 1)
print(finished!, startCycle!, offset)
let truncWeights = Array(weights[startCycle!...(finished! - 1)])
print(truncWeights.count, finished! - startCycle!)
print(truncWeights[offset])
