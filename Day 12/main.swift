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

print(input)

func genAndFilterSprings(springs: [Character], count: [Int]) -> Int {
    // generate strings
    for (idx, char) in springs.enumerated() {
        var p = 0
        if char == "?" {
            var springs1 = springs
            springs1[idx] = "."
            p += genAndFilterSprings(springs: springs1, count: count)
            var springs2 = springs
            springs2[idx] = "#"
            p += genAndFilterSprings(springs: springs2, count: count)
            return p
        }
    }
    // if no generation occured, then check and return result
    var curCount = 0
    var countStack = Array(count.reversed())
    for char in springs {
        switch char {
        case "#":
            curCount += 1
        case ".":
            if curCount > 0 {
                if countStack.isEmpty {
                    // print("empty", springs.reduce(into: "") {$0 += String($1)}, count)
                    return 0
                }
                if curCount == countStack.last {
                    curCount = 0
                    _ = countStack.popLast()
                } else {
                    // print("didn't match", springs.reduce(into: "") {$0 += String($1)}, count)
                    return 0
                }
            }
        default:
            fatalError("unexpected character")
        }
    }
    if curCount > 0 {
        if countStack.isEmpty {
            // print("final empty", springs.reduce(into: "") {$0 += String($1)}, count)
            return 0
        }
        if curCount == countStack.last {
            _ = countStack.popLast()
        }
    }
    if countStack.isEmpty {
        return 1
    }
    // print("reached end", springs.reduce(into: "") {$0 += String($1)}, count)
    return 0
}

// for each line in input
var permutations = 0
for line in input {
    var p = genAndFilterSprings(springs: line.springs, count: line.count)
    print(p, line.springs.reduce(into: "") {$0 += String($1)}, line.count)
    permutations += p
}

print(permutations)
