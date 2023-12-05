//
//  main.swift
//  Day 5
//
//  Created by Scott Dier on 2023-12-05.
//

import Foundation

let input = """
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
""".components(separatedBy: "\n\n")

print(input)

let seeds = input[0].components(separatedBy: ": ")[1].components(separatedBy: .whitespaces).map({Int($0)!})

print (seeds)

typealias Translation  = (dest: Int, source: Int, range: Int)

let tr = input[1...]
    .map({$0.components(separatedBy: ":\n")[1].components(separatedBy: .newlines)
            .map({
                let v = $0.components(separatedBy: .whitespaces)
                return Translation(dest: Int(v[0])!, source: Int(v[1])!, range: Int(v[2])!)
            })
    })

print(tr)

var output : [Int] = []

for seed in seeds {
    var s = seed
    for translateList in tr {
        for t in translateList{
            if t.source..<(t.source+t.range) ~= s {
                s = t.dest + s - t.source
                break
            }
        }
    }
    output.append(s)
}
print(output)
print(output.min()!)
