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

typealias Translation = (dest: Int, source: Int, range: Int)
var seedranges : [Translation] = []

var i = 0
while i < seeds.count {
    seedranges.append((dest: seeds[i], source: seeds[i], range: seeds[i+1]))
    i += 2
}

print(seeds)
print(seedranges)


let tr = input[1...]
    .map({$0.components(separatedBy: ":\n")[1].components(separatedBy: .newlines)
            .map({
                let v = $0.components(separatedBy: .whitespaces)
                return Translation(dest: Int(v[0])!, source: Int(v[1])!, range: Int(v[2])!)
            })
    })

print(tr)

// merge translation lists

i = 0
var optTr = seedranges
print(optTr.reduce(into: Int(0)) {
    $0 += $1.range
})

// change to ordering the lists properly at each step
// perhaps instead of trying to do all at once, do one at a time.

while i < tr.count {
    print("--- tr", i)
    optTr.sort(by: {$0.source < $1.source})
nextT: for (ttIdx, tt) in optTr.enumerated() {
        // retain start / end
        // split into dest ranges
        // translate in place
        var t = tt
        var tIdx = ttIdx
        // print("--- t", tIdx, t)
        for nt in tr[i].sorted(by: {$0.source < $1.source}) {
            let tRange = t.source..<(t.source+t.range)
            let tRangeDest = t.dest..<(t.dest+t.range)
            let ntRange = nt.source..<(nt.source+nt.range)
            let ntRangeDest = nt.dest..<(nt.dest+nt.range)
            if ntRange.overlaps(tRangeDest) {
            print("--- nt", tIdx, t, nt)
                //print("overlap", nt)
                // 4 cases:
                // tRange is contained by
                // output 1 range
                // contains(new)
                if (ntRange.lowerBound <= tRangeDest.lowerBound &&
                    ntRange.upperBound >= tRangeDest.upperBound) {
                  print("contained")
                    optTr[tIdx] = (
                        dest: ntRangeDest.lowerBound + tRangeDest.lowerBound - ntRange.lowerBound,
                        source: tRange.lowerBound,
                        range: t.range)
                    // no remainder
                    continue nextT
                // tRange overlaps above
                // output 2 ranges
                // below(original), contains(new)
                } else if (ntRange.lowerBound >= tRangeDest.lowerBound &&
                           ntRange.upperBound >= tRangeDest.upperBound) {
                    print("above", tRange, tRangeDest, ntRange, ntRangeDest)
                    let oRange = t.range
                    optTr[tIdx] = (
                        dest: ntRangeDest.lowerBound,
                        source: tRange.lowerBound + ntRange.lowerBound - tRangeDest.lowerBound,
                        range: tRangeDest.upperBound - ntRange.lowerBound)
                    optTr.append((dest: tRangeDest.lowerBound,
                                  source: tRange.lowerBound,
                                  range: ntRange.lowerBound - tRangeDest.lowerBound))
                    // remainder
                    t = optTr.last!
                    tIdx = optTr.endIndex - 1
                    if(oRange != (tRangeDest.upperBound - ntRange.lowerBound) + (ntRange.lowerBound - tRangeDest.lowerBound)) {
                        fatalError()
                    }
                // tRange overlaps below
                // output 2 ranges
                // contains(new), above(original)
                } else if (ntRange.lowerBound <= tRangeDest.lowerBound &&
                           ntRange.upperBound <= tRangeDest.upperBound) {
                    print("below", tRange, tRangeDest, ntRange, ntRangeDest)
                    let oRange = t.range
                    optTr[tIdx] = (
                        dest: ntRangeDest.lowerBound + tRangeDest.lowerBound - ntRange.lowerBound,
                        source: tRange.lowerBound,
                        range: ntRange.upperBound - tRangeDest.lowerBound)
                    optTr.append((
                        dest: ntRange.upperBound,
                        source: tRange.lowerBound + ntRange.upperBound - tRangeDest.lowerBound + 1,
                        range: tRangeDest.upperBound - ntRange.upperBound))
                    t = optTr.last!
                    tIdx = optTr.endIndex - 1
                    if (oRange != (ntRange.upperBound - tRangeDest.lowerBound) + (tRangeDest.upperBound - ntRange.upperBound)) {
                        print(t)
                        print(nt)
                        print((
                            dest: ntRangeDest.lowerBound + tRangeDest.lowerBound - ntRange.lowerBound,
                            source: tRange.lowerBound,
                            range: ntRange.upperBound - tRangeDest.lowerBound))
                        print((
                            dest: ntRange.upperBound,
                            source: tRange.lowerBound + ntRange.upperBound - tRangeDest.lowerBound + 1,
                            range: tRangeDest.upperBound - ntRange.upperBound))
                        print(tt.range, (ntRange.upperBound - tRangeDest.lowerBound) + (tRangeDest.upperBound - ntRange.upperBound))
                        fatalError()
                    }
                // a subset of tRange is affected
                // output 3 ranges
                // below(original), contains(new), above(original)
                } else if (ntRange.lowerBound >= tRangeDest.lowerBound &&
                           ntRange.upperBound <= tRangeDest.upperBound) {
                    print("subset", tRange, tRangeDest, ntRange, ntRangeDest)
                    print(optTr[tIdx])
                    print(optTr.reduce(into: Int(0)) {
                        $0 += $1.range
                    })
                    let oRange = t.range
                    optTr[tIdx] = (
                        dest: ntRangeDest.lowerBound,
                        source: tRange.lowerBound + ntRange.lowerBound - tRangeDest.lowerBound,
                        range: ntRange.count
                    )
                    optTr.append((
                        dest: tRangeDest.lowerBound,
                        source: tRange.lowerBound,
                        range: ntRange.lowerBound - tRangeDest.lowerBound))
                    optTr.append((
                        dest: ntRange.upperBound,
                        source: tRange.lowerBound + ntRange.upperBound - tRangeDest.lowerBound + 1,
                        range: tRangeDest.upperBound - ntRange.upperBound))
                    t = optTr.last!
                    tIdx = optTr.endIndex - 1
                    print(oRange, ntRange.count + (ntRange.lowerBound - tRangeDest.lowerBound) + (tRangeDest.upperBound - ntRange.upperBound))
                    if(oRange != (ntRange.count + (ntRange.lowerBound - tRangeDest.lowerBound) + (tRangeDest.upperBound - ntRange.upperBound))) {
                        fatalError()
                    }
                } else {
                    fatalError("none matched")
                }
                // When no cases match just leave it alone as it passes through this layer of filtering.
            }
        }
    }
    print(optTr.reduce(into: Int(0)) {
        $0 += $1.range
    })
    i += 1
}
print(optTr.sorted(by: {$0.dest < $1.dest}).first!)
