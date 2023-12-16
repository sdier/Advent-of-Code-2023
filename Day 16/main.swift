//
//  main.swift
//  Day 16
//
//  Created by Scott Dier on 2023-12-16.
//

import Foundation

let input = #"""
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
"""#.components(separatedBy: .newlines).map({Array($0)})

var energy = Array(repeating: Array(repeating: Character("."), count: input[0].count), count: input.count)
var energyDir = Array(repeating: Array(repeating: [Directions](), count: input[0].count), count: input.count)

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

func shine(beam: Coordinate, direction: Directions) {
    if beam.y >= input.count || beam.x >= input[0].count || beam.x < 0 || beam.y < 0 {
        return
    }
    if energyDir[beam.y][beam.x].contains(direction) {
        return
    }
    energy[beam.y][beam.x] = "#"
    energyDir[beam.y][beam.x].append(direction)
    switch input[beam.y][beam.x] {
    case ".":
        shine(beam: (x: beam.x + directions[direction]!.x, y: beam.y + directions[direction]!.y), direction: direction)
    case #"\"#:
        var newDir : Directions?
        switch direction {
        case .up:
            newDir = .left
        case .down:
            newDir = .right
        case .left:
            newDir = .up
        case .right:
            newDir = .down
        }
        shine(beam: (x: beam.x + directions[newDir!]!.x, y: beam.y + directions[newDir!]!.y), direction: newDir!)
    case "/":
        var newDir : Directions?
        switch direction {
        case .up:
            newDir = .right
        case .down:
            newDir = .left
        case .left:
            newDir = .down
        case .right:
            newDir = .up
        }
        shine(beam: (x: beam.x + directions[newDir!]!.x, y: beam.y + directions[newDir!]!.y), direction: newDir!)
    case "|":
        var newDirs : [Directions] = []
        switch direction {
        case .up:
            newDirs.append(.up)
        case .down:
            newDirs.append(.down)
        case .left:
            fallthrough
        case .right:
            newDirs.append(.up)
            newDirs.append(.down)
        }
        for newDir in newDirs{
            shine(beam: (x: beam.x + directions[newDir]!.x, y: beam.y + directions[newDir]!.y), direction: newDir)
        }
    case "-":
        var newDirs : [Directions] = []
        switch direction {
        case .up:
            fallthrough
        case .down:
            newDirs.append(.left)
            newDirs.append(.right)
        case .left:
            newDirs.append(.left)
        case .right:
            newDirs.append(.right)
        }
        for newDir in newDirs{
            shine(beam: (x: beam.x + directions[newDir]!.x, y: beam.y + directions[newDir]!.y), direction: newDir)
        }
    default:
        fatalError()
    }
}

shine(beam: (0,0), direction: .right)

print(energy.reduce(into: "", {$0 += String($1) + "\n"}))
print(energy.reduce(into: 0, { $0 += $1.reduce(into: 0, { if $1 == "#" { $0 += 1 }})}))
