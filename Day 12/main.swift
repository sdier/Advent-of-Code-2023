//
//  main.swift
//  Day 12
//
//  Created by Scott Dier on 2023-12-14.
//

import Foundation

let input = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
""".components(separatedBy: .newlines)
    .map({$0.components(separatedBy: .whitespaces)})
    .map({(springs: Array($0[0]), count: $0[1].components(separatedBy: ",").map({Int($0)!}))})

var cache : [String: Int] = [:]

var calls = 0

func genAndFilterSprings(springs: [Character], count: [Int], currentCount: Int?, index: Int?, countStack: [Int]?) -> Int {
    var curCount = 0
    calls += 1

    // rebuild state from previous checks
    if currentCount != nil {
        curCount = currentCount!
    }
    var cStack: [Int] = []
    if countStack != nil {
        cStack = countStack!
    } else {
        cStack = Array(count.reversed())
    }
    var cSprings = springs
    if index != nil {
        // chop off front of array
        cSprings = Array(springs[index!...])
    }

    for (idx, char) in cSprings.enumerated() {
        switch char {
        case "#":
            if cStack.isEmpty || curCount > cStack.last! {
                // print("too many", cSprings.reduce(into: "") {$0 += String($1)}, cStack)
                return 0
            }
            curCount += 1
        case ".":
            if curCount > 0 {
                if cStack.isEmpty {
                    // print("empty", cSprings.reduce(into: "") {$0 += String($1)}, count)
                    return 0
                }
                if curCount == cStack.last {
                    curCount = 0
                    _ = cStack.popLast()
                } else {
                    //print("didn't match", cSprings.reduce(into: "") {$0 += String($1)}, cStack)
                    return 0
                }
            }
        case "?":
            let pCacheKey = cSprings.reduce(into: "", {$0 += String($1)}) + "/" + cStack.reduce(into: "", {$0 += String($1) + ","}) + "/" + String(curCount)
            if cache.keys.contains(pCacheKey) {
                return cache[pCacheKey]!
            }

            var p = 0
            var springs1 = cSprings
            springs1[idx] = "."
            p += genAndFilterSprings(springs: springs1, count: count, currentCount: curCount, index: idx, countStack: cStack)

            var springs2 = cSprings
            springs2[idx] = "#"
            p += genAndFilterSprings(springs: springs2, count: count, currentCount: curCount, index: idx, countStack: cStack)

            cache[pCacheKey] = p
            return p
        default:
            fatalError("unexpected character")
        }
    }
    if curCount > 0 {
        if cStack.isEmpty {
            // print("final empty", cSprings.reduce(into: "") {$0 += String($1)}, count)
            return 0
        }
        if curCount == cStack.last {
            _ = cStack.popLast()
        }
    }
    if cStack.isEmpty {
        return 1
    }
    // print("reached end", cSprings.reduce(into: "") {$0 += String($1)}, count)
    return 0
}

// for each line in input
var permutations = 0
for line in input {
    var springs : [Character] = []
    var count : [Int] = []
    var p = 0
    let times = 5
    for _ in 0..<(times-1) {
        springs.append(contentsOf: line.springs)
        springs.append("?")
        count.append(contentsOf: line.count)
    }
    springs.append(contentsOf: line.springs)
    count.append(contentsOf: line.count)
    p = genAndFilterSprings(springs: springs, count: count, currentCount: nil, index: nil, countStack: nil)
    print(calls)
    calls = 0
    permutations += p
}

print(permutations)
