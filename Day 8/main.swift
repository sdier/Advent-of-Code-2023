//
//  main.swift
//  Day 8
//
//  Created by Scott Dier on 2023-12-09.
//

import Foundation
import Euler

typealias Location = (left: String, right: String)

let map : [String: Location] = """
11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
""".components(separatedBy: .newlines).reduce(into: [String: Location]()) {
    let x = $1.components(separatedBy: " = ")
    let y = x[1].components(separatedBy: ", ")
        .map({$0.trimmingCharacters(in: .punctuationCharacters)})
    $0[x[0]] = (y[0],y[1])
}

let directions : [Character] = Array("""
LR
""")

print(map)
print(directions)

var currentLocations = Array(map.filter({$0.key.suffix(1) == "A"}).keys)
var goalLocations = Array(map.filter({$0.key.suffix(1) == "Z"}).keys)
var steps = Array(repeating: 0, count: currentLocations.count)

print(currentLocations)
print(goalLocations)

for (idx, initialLocation) in currentLocations.enumerated() {
    var directionLoc = 0
    var currentLocation = initialLocation
    while !goalLocations.contains(currentLocation) {
        switch directions[directionLoc] {
        case "R":
            currentLocation = map[currentLocation]!.right
        case "L":
            currentLocation = map[currentLocation]!.left
        default:
            fatalError()
        }
        steps[idx] += 1
        directionLoc += 1
        if directionLoc == directions.count {
            directionLoc = 0
        }
    }
}

print(steps)
try print(Tables().LCM(array: steps.map({BigInt($0)})))
