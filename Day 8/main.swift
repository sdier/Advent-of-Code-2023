//
//  main.swift
//  Day 8
//
//  Created by Scott Dier on 2023-12-09.
//

import Foundation

typealias Location = (left: String, right: String)

let map : [String: Location] = """
AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
""".components(separatedBy: .newlines).reduce(into: [String: Location]()) {
    let x = $1.components(separatedBy: " = ")
    let y = x[1].components(separatedBy: ", ")
        .map({$0.trimmingCharacters(in: .punctuationCharacters)})
    $0[x[0]] = (y[0],y[1])
}

let directions : [Character] = Array("""
LLR
""")

print(map)
print(directions)

var currentLocation = "AAA"
let goalLocation = "ZZZ"
var directionLoc = 0
var steps = 0

while currentLocation != goalLocation {
    switch directions[directionLoc] {
    case "R":
        currentLocation = map[currentLocation]!.right
    case "L":
        currentLocation = map[currentLocation]!.left
    default:
        fatalError()
    }
    steps += 1
    directionLoc += 1
    if directionLoc == directions.count {
        directionLoc = 0
    }
}

print(steps)

