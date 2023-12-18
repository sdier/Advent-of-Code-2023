//
//  main.swift
//  Day 17
//
//  Created by Scott Dier on 2023-12-18.
//

import Foundation

let input = """
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
""".components(separatedBy: .newlines).map({Array($0)})

enum Directions: Comparable {
    case up
    case right
    case down
    case left
}

typealias Coordinate = (x: Int, y: Int)

let directions : [Directions : Coordinate] = [
    .up : (x: 0, y:-1),
    .right : (x: 1, y:0),
    .down : (x: 0, y:1),
    .left : (x: -1, y:0)]

let fromTo : [Directions: Directions] = [
    .up: .down,
    .down: .up,
    .left: .right,
    .right: .left,
]

let allowed : [Directions: [Directions]] = [
    .up: [.right, .up, .left],
    .down: [.down, .right, .left],
    .left: [.left, .down, .up],
    .right: [.right, .down, .up],
]

var cache : [Int: Int] = [:]


func minTraverse(start: Coordinate, end: Coordinate, estimate: Double) -> Int {
    var cycles = 0
    var stack : [(pos: Coordinate, lastDir: Directions?, sameDir: Int, loss: Int, seen: Set<Int>)] = []
    stack.append((pos: start, lastDir: nil, sameDir: 0, loss: 0, seen: []))
    var results : [Int] = []
    while stack.count != 0 {
        // stack.sort(by: {Decimal($0.loss)/Decimal($0.seen.count) > Decimal($1.loss)/Decimal($1.seen.count)})
        // stack.sort(by: {$0.seen.count > $1.seen.count})
        stack.sort(by: { $0.loss > $1.loss })
        //let (pos, lastDir, sameDir, loss, seen) = stack.popLast()!
        //stack.shuffle()
        let (pos, lastDir, sameDir, loss, seen) = stack.removeLast()
        cycles += 1

        if pos.x < 0 || pos.y < 0 || pos.x >= input[0].count || pos.y >= input.count {
            continue
        }

        let posLoss = loss + Int(String(input[pos.y][pos.x]))!
        if lastDir != nil {
            let cacheKey = (String(pos.y) + "-" + String(pos.x) + "-" + String(lastDir!.hashValue) + "-" + String(sameDir)).hashValue
            if cache.keys.contains(cacheKey) && posLoss >= cache[cacheKey]! {
                continue
            }
            cache[cacheKey] = posLoss
        }

        if seen.count > 10 && Double(posLoss) > estimate * Double(seen.count + 1) {
            continue
        }

        if results.min() != nil && (loss + Int(String(input[pos.y][pos.x]))!) >= results.min()! {
            continue
        }
        if pos == end {
            print(loss + Int(String(input[pos.y][pos.x]))!, results.min(), cycles)
            results.append(loss + Int(String(input[pos.y][pos.x]))!)
        }
        var allowedDirs : [Directions] = []
        if lastDir != nil {
            allowedDirs = allowed[lastDir!]!
        } else {
            allowedDirs = [.right, .down]
        }
        if sameDir >= 2 {
            allowedDirs.removeAll(where: {$0 == lastDir})
        }
        //allowedDirs.shuffle()

        for dir in allowedDirs {
            var sd = sameDir
            if dir == lastDir {
                sd += 1
            } else {
                sd = 0
            }
            let seenKey = (String(pos.y) + "-" + String(pos.x)).hashValue
            if seen.contains(seenKey) {
                continue
            }
            var s = Set(seen)
            s.insert(seenKey)
            stack.append((pos: (x: pos.x + directions[dir]!.x, y: pos.y + directions[dir]!.y),
                          lastDir: dir,
                          sameDir: sd,
                          loss: loss + Int(String(input[pos.y][pos.x]))!,
                          seen: s))
        }
    }
    print(results)
    return results.min()!
}

let end = Coordinate(x: input[0].count - 1, y: input.count - 1)
let start = Coordinate(x: 0, y: 0)
let estimate = Double(input.reduce(into: 0, {$0 += $1.reduce(into:0, {$0 += Int(String($1))!})})) / Double(input.count*input.count)
print(estimate)

let a = minTraverse(start: start, end: end, estimate: 5)
print(a)

// 900 too low
//
