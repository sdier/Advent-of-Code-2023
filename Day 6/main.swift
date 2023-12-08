//
//  main.swift
//  Day 6
//
//  Created by Scott Dier on 2023-12-08.
//

import Foundation

typealias Race = (time: Int, distance: Int)

let races : [Race] = [
    (time: 71530, distance: 940200),
]

var raceMult = 1

for race in races {
    var wins = 0
    for i in 0...race.time {
        if (i * (race.time - i) > race.distance) {
            wins += 1
        }
    }
    raceMult *= wins
}

print(raceMult)
