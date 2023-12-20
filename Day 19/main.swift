//
//  main.swift
//  Day 19
//
//  Created by Scott Dier on 2023-12-20.
//

import Foundation

let input = """
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
""".components(separatedBy: "\n\n")

enum Opcode: String {
    case gt = ">"
    case lt = "<"
    case none
}

enum Register: String {
    case x
    case m
    case a
    case s
    case none
}

let r2a: [Register: Int] = [
    .x: 0,
    .m: 1,
    .a: 2,
    .s: 3,
]

typealias Op = (op: Opcode, reg: Register, cmp: Int?, jmp: String)

let instructions = input[0].description.components(separatedBy: .newlines).reduce(into: [String: String](), {
    let m = $1.wholeMatch(of: /([^{]*){([^}]*)}/)!
    $0[String(m.output.1)] = String(m.output.2)
}).reduce(into: [String: [Op]](), {
    let l = $1.value.components(separatedBy: ",")
    for o in l {
        let m = o.wholeMatch(of: /((x|m|a|s)(<|>)([0-9]*):)?([a-zAA-Z]*)/)
        $0[$1.key, default: []].append((op: Opcode(rawValue: String(m!.output.3 ?? "none"))!,
                                        reg: Register(rawValue: String(m!.output.2 ?? "none"))!,
                                        cmp: Int(m!.output.4 ?? ""), jmp: String(m!.output.5)))
    }
})

let data = input[1].components(separatedBy: .newlines).reduce(into: [[Int]](), {
    let m = $1.wholeMatch(of: /{x=([0-9]*),m=([0-9]*),a=([0-9]*),s=([0-9]*)}/)
    $0.append([Int(m!.output.1)!, Int(m!.output.2)!, Int(m!.output.3)!, Int(m!.output.4)!])
})

var accepted = 0
var rejected = 0

nextPart: for p in data {
    var wkf = "in"
nextWkf: while true {
    switch wkf {
    case "A":
        accepted += p.reduce(into: 0, {$0 += $1})
        continue nextPart
    case "R":
        rejected += p.reduce(into: 0, {$0 += $1})
        continue nextPart
    default:
        break
    }
        let ops = instructions[wkf]!
        for op in ops {
            switch op {
            case (op: .gt, reg: let r, cmp: let c, jmp: let j):
                if p[r2a[r]!] > c! {
                    wkf = j
                    continue nextWkf
                }
            case (op: .lt, reg: let r, cmp: let c, jmp: let j):
                if p[r2a[r]!] < c! {
                    wkf = j
                    continue nextWkf
                }
            case (op: .none, reg: _, cmp: _, jmp: let j):
                wkf = j
                continue nextWkf
            }
        }
    }
}

print(accepted)
