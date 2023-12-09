//
//  main.swift
//  Day 7
//
//  Created by Scott Dier on 2023-12-08.
//

import Foundation

typealias Hand = (cards: String, bet: Int)

let input = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
""".components(separatedBy: .newlines)
    .map({
        let x = $0.components(separatedBy: .whitespaces)
        return Hand(x[0],Int(x[1])!)
    })

let cardID : [Character] = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]

var rankedHands : [Int: [Hand]] = [:]

// Rank hands
for hand in input {
    let c = Array(hand.cards)
    let cardCount = c.reduce(into: [Int: Int]()) {
        $0[cardID.firstIndex(of: $1)!, default:0] += 1
    }.reduce(into: [Int: [Int]]()) {
        $0[$1.value, default: []].append($1.key)
    }
    print(cardCount)
    if (cardCount.keys.contains(5) || 
        cardCount.keys.contains(4) && cardCount.keys.contains(1) && cardCount[1]!.contains(0) ||
        cardCount.keys.contains(3) && cardCount.keys.contains(2) && cardCount[2]!.contains(0) ||
        cardCount.keys.contains(2) && cardCount.keys.contains(3) && cardCount[3]!.contains(0) ||
        cardCount.keys.contains(1) && cardCount.keys.contains(4) && cardCount[4]!.contains(0)) {
        rankedHands[6, default: []].append(hand)
    } else if (cardCount.keys.contains(4) ||
               cardCount.keys.contains(3) && cardCount.keys.contains(1) && cardCount[1]!.contains(0) ||
               cardCount.keys.contains(2) && cardCount[2]!.count > 1 && cardCount[2]!.contains(0) ||
               cardCount.keys.contains(1) && cardCount.keys.contains(3) && cardCount[3]!.contains(0)) {
        rankedHands[5, default: []].append(hand)
    } else if (cardCount.keys.contains(3) && cardCount.keys.contains(2) ||
               cardCount.keys.contains(2) && cardCount[2]!.count > 1 && cardCount.keys.contains(1) && cardCount[1]!.contains(0)) {
        rankedHands[4, default: []].append(hand)
    } else if (cardCount.keys.contains(3) ||
               cardCount.keys.contains(2) && cardCount.keys.contains(1) && cardCount[1]!.contains(0) ||
               cardCount.keys.contains(1) && cardCount.keys.contains(2) && cardCount[2]!.contains(0)) {
        rankedHands[3, default: []].append(hand)
    } else if (cardCount.keys.contains(2) && cardCount[2]!.count > 1 ||
               cardCount.keys.contains(2) && cardCount.keys.contains(1) && cardCount[1]!.contains(0)) {
        rankedHands[2, default: []].append(hand)
    } else if (cardCount.keys.contains(2) ||
               cardCount.keys.contains(1) && cardCount[1]!.count > 1 && cardCount[1]!.contains(0)) {
        rankedHands[1, default: []].append(hand)
    } else {
        rankedHands[0, default: []].append(hand)
    }
}

print("---")
print(rankedHands.sorted(by: {$0.key < $1.key}))
print("---")

var finalRankedHands : [Hand] = []

for hands in rankedHands.sorted(by: {$0.key > $1.key}) {
    if (hands.value.count == 1) {
        finalRankedHands.append(hands.value[0])
        continue
    } else {
        var handsLeft = hands.value
        var i = 0
        //print("---", handsLeft)
        var handsToTry = handsLeft
        while handsLeft.count > 0 {
            print("--- idx", i)
            var highIdx : Int? = nil
            var high : Int? = nil
            var dupe = false
            var dupeHands : [Hand] = []
            for (idx, hand) in handsToTry.enumerated() {
                let thisCardID = Int(cardID.firstIndex(of: Array(hand.cards)[i])!)
                if highIdx == nil || thisCardID > high! {
                    //print ("new high", Array(hand.cards)[i], thisCardID, idx)
                    highIdx = idx
                    high = thisCardID
                    dupe = false
                    dupeHands = [hand]
                } else if (thisCardID == high) {
                    //print("dupe", thisCardID)
                    dupe = true
                    dupeHands.append(hand)
                }
            }
            if !dupe && highIdx != nil {
                //print("remove")
                finalRankedHands.append(handsToTry[highIdx!])
                handsLeft.remove(at: handsLeft.firstIndex(where: {$0.cards == handsToTry[highIdx!].cards})!)
                handsToTry = handsLeft
                i = 0
                continue
            } 
            handsToTry = dupeHands
            i += 1
        }
    }
}
finalRankedHands.reverse()
print(finalRankedHands)
var score = 0
for (i, hand) in finalRankedHands.enumerated() {
    score += hand.bet * (i+1)
}
print(score)
