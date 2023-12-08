//
//  main.swift
//  Day 6
//
//  Created by Scott Dier on 2023-12-08.
//

import Foundation
import Algorithms

typealias Race = (time: Int, distance: Int)

let races : [Race] = [
    (time: 7, distance: 9),
    (time: 15, distance: 40),
    (time: 30, distance: 200)
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
