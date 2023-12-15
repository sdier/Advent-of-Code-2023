//
//  main.swift
//  Day 13
//
//  Created by Scott Dier on 2023-12-15.
//

import Foundation

let input = """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
""".components(separatedBy: "\n\n").map({$0.components(separatedBy: .newlines)})

var horiz : [Int] = []
var vert : [Int] = []

func findPivot(_ note: [String]) -> Int? {
    nextPivot: for pivot in 0..<note.count-1 {
        for cIdx in 0...pivot {
            let compareTo = pivot + 1 + (pivot - cIdx)
            if compareTo < note.count && note[cIdx] != note[compareTo] {
                continue nextPivot
            }
        }
        return pivot
    }
    return nil
}

func rotate(_ note: [String]) -> [String] {
    var newNote = Array(repeating: "", count: note[0].count)
    for charIdx in 0..<note[0].count {
        for row in note {
            newNote[charIdx].append(Array(row)[charIdx])
        }
    }
    return(newNote)
}

nextNote: for note in input {
    let h = findPivot(note)
    if h != nil {
        horiz.append(h! + 1)
    }
    let v = findPivot(rotate(note))
    if v != nil {
        vert.append(v! + 1)
    }
}

let total = horiz.reduce(into: 0, {$0 += $1}) * 100 + vert.reduce(into: 0, {$0 += $1})
print("horiz", horiz, "vert", vert, "total", total)
