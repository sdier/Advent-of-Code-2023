//
//  main.swift
//  Day 17
//
//  Created by Scott Dier on 2023-12-18.
//

import Foundation
import DequeModule

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

enum Directions: Int {
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

let allowed : [Directions: [Directions]] = [
    .up: [.up, .right, .left],
    .down: [.down, .right, .left],
    .left: [.left, .down, .up],
    .right: [.right, .down, .up],
]

var cache : [String: Int] = [:]

func minTraverse(start: Coordinate, end: Coordinate, total: Int) -> Int {
    var lastPrint = 0
    var cycles = 0
    var stack : Deque<(pos: Coordinate, lastDir: Directions?, sameDir: Int, loss: Int)> = []
    stack.append((pos: start, lastDir: nil, sameDir: 0, loss: 0))
    var results : [Int] = []
    while stack.count != 0 {
        let (pos, lastDir, sameDir, loss) = stack.removeFirst()
        cycles += 1
        if loss / 100 > lastPrint {
            print("loss:", loss, "cycles:", cycles)
            lastPrint = loss / 100
        }

        if pos.x < 0 || pos.y < 0 || pos.x >= input[0].count || pos.y >= input.count {
            continue
        }

        let posLoss = loss + Int(String(input[pos.y][pos.x]))!
        if lastDir != nil {
            let cacheKey = String(pos.y) + "-" + String(pos.x) + "-" + String(lastDir!.rawValue) + "-" + String(sameDir)
            if cache.keys.contains(cacheKey) && posLoss >= cache[cacheKey]! {
                continue
            }
            cache[cacheKey] = posLoss
        }

        if posLoss > total {
            continue
        }

        if results.min() != nil && posLoss >= results.min()! {
            continue
        }

        if pos == end {
            if sameDir < 3 {
                print("close", posLoss, results.min(), cycles)
                continue
            }
            print("result", posLoss, results.min(), cycles)
            results.append(posLoss)
        }

        var allowedDirs : [Directions] = []
        var dirMult = 0

        if lastDir != nil && sameDir < 3 {
            allowedDirs.append(lastDir!)
        } else if lastDir != nil {
            allowedDirs = allowed[lastDir!]!
            if sameDir >= 9 {
                allowedDirs.removeAll(where: {$0 == lastDir})
            }
        } else {
            allowedDirs = [.right, .down]
        }

        for dir in allowedDirs {
            var sd = sameDir
            var sIdx = 0
            if dir != lastDir || lastDir == nil {
                sd = 3
                dirMult = 3
            } else {
                sd += 1
            }
            if lastDir == nil {
                sIdx = 1
            }
            let fPos : Coordinate = (x: pos.x + directions[dir]!.x * (dirMult + 1), y: pos.y + directions[dir]!.y * (dirMult + 1))
            if fPos.x < 0 || fPos.y < 0 || fPos.x >= input[0].count || fPos.y >= input.count {
                continue
            }
            var l = loss
            for i in sIdx...dirMult {
                let mPos : Coordinate = (x: pos.x + (directions[dir]!.x * i), y: pos.y + (directions[dir]!.y * i))
                l += Int(String(input[mPos.y][mPos.x]))!
            }
            stack.append((pos: fPos,
                          lastDir: dir,
                          sameDir: sd,
                          loss: l))
        }
    }
    print(results)
    print(cycles)
    return results.min()!
}

let end = Coordinate(x: input[0].count - 1, y: input.count - 1)
let start = Coordinate(x: 0, y: 0)
print(start, end)
let a = minTraverse(start: start, end: end, total: 1200)
print(a)
