//
//  main.swift
//  Day 4
//
//  Created by Scott Dier on 2023-12-04.
//

import Foundation
import Algorithms

var input = """
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
""".components(separatedBy: .newlines).map({$0.components(separatedBy: ": ")})

let gameList = Dictionary(uniqueKeysWithValues: input.lazy.map(
    {
        (Int($0[0].components(separatedBy: .whitespaces).last!)!,
         $0[1].components(separatedBy: " | ")
            .map({$0.components(separatedBy: .whitespaces).filter({$0 != ""})})
        )
    }
))

// print(gameList)

var totalScore : Decimal = 0
var cards : [Int: Int] = [:]

for game in gameList.sorted(by: {$0.key < $1.key}) {
    var score = -1
    // every card counts for itself
    cards[game.key, default: 0] += 1
    for (winner, found) in product(game.value[0], game.value[1]) {
        if winner == found {
            score += 1
        }
    }
    if score >= 0 {
        print(game.key, score+1)
        totalScore += pow(2, score)
        var cardInc = 1
        while cardInc <= score + 1 {
            cards[game.key+cardInc, default: 0] += cards[game.key]!
            cardInc += 1
        }
    }
}

print(cards.sorted(by: {$0.key < $1.key}))

print(totalScore)
print(cards.reduce(into: Int(0)) {
    $0 += $1.value
})

