//
//  main.swift
//  Day 2
//
//  Created by Scott Dier on 2023-12-02.
//

import Foundation

let input = """
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
""".components(separatedBy: .newlines).map({$0.components(separatedBy: ": ")})

let gameList = Dictionary(uniqueKeysWithValues: input.lazy.map(
    {
        (Int($0[0].components(separatedBy: .whitespaces)[1])!,
         $0[1].components(separatedBy: "; ")
            .map({$0.components(separatedBy: ", ")
                    .map({$0.components(separatedBy: .whitespaces)})
                    .reduce(into: [String: Int]()) {
                        $0[$1[1]] = Int($1[0])
                    }
            })
        )
    }))

let gameFilter = [
    "red": 12,
    "green": 13,
    "blue": 14
]

var gameScore = 0
gameLoop: for game in gameList {
    let gameIdx = game.key
    for result in game.value {
        for filter in gameFilter {
            if result.keys.contains(filter.key) && result[filter.key]! > filter.value {
                continue gameLoop
            }
        }
    }
    gameScore += gameIdx
}

print(gameScore)
