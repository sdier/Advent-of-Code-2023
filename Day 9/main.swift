//
//  main.swift
//  Day 9
//
//  Created by Scott Dier on 2023-12-09.
//

import Foundation

let input = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
""".components(separatedBy: .newlines).map({$0.components(separatedBy: .whitespaces).map({Int($0)!})})

print(input)

// https://rosettacode.org/wiki/Forward_difference
func forwardsDifference<T: SignedNumeric>(of arr: [T]) -> [T] {
    return zip(arr.dropFirst(), arr).map({ $0.0 - $0.1 })
}

func nthForwardsDifference<T: SignedNumeric>(of arr: [T], n: Int) -> [T] {
  assert(n >= 0)

  switch (arr, n) {
  case ([], _):
    return []
  case let (arr, 0):
    return arr
  case let (arr, i):
    return nthForwardsDifference(of: forwardsDifference(of: arr), n: i - 1)
  }
}

var seqNext : [Int] = []

for seq in input {
    // What is this?
    var seqDiff = seq
    var seqHist : [Int] = [seq.last!]
    var i = 1
    while !seqDiff.allSatisfy({$0 == seqDiff[0]}) {
        seqDiff = nthForwardsDifference(of: seq, n: i)
        seqHist.append(seqDiff.last!)
        i += 1
    }
    // What is the next number?
    seqNext.append(seqHist.reduce(into: Int(0)) {
        $0 += $1
    })
}

print(seqNext.reduce(into: Int()) {
    $0 += $1
})
