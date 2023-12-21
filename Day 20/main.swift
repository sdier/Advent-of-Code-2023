//
//  main.swift
//  Day 20
//
//  Created by Scott Dier on 2023-12-21.
//

import Foundation
import DequeModule

let input = """
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
"""

typealias Module = (type: Modules, lastPulse: [String: Pulses]?, flipState: Bool?, destinations: [String])

enum Pulses: Int {
    case low
    case high
}

enum Modules : String {
    case flipflop = "%"
    case conjunction = "&"
    case broadcaster = "broadcaster"
}

// pulses are handled on a stack, one stack per pulse

var moduleConf : [String: Module] = [:]

for line in input.components(separatedBy: .newlines) {
    let m = line.wholeMatch(of: /(%|&)?([a-zA-Z]*) -> (.*)/)!
    let dest = m.output.3.components(separatedBy: ", ")
    if m.output.2 == "broadcaster" {
        moduleConf["broadcaster"] = Module(type: .broadcaster, lastPulse: nil, flipState: nil, destinations: dest)
    } else if m.output.1 == "%" {
        moduleConf[String(m.output.2)] = Module(type: .flipflop, lastPulse: nil, flipState: false, destinations: dest)
    } else if m.output.1 == "&" {
        moduleConf[String(m.output.2)] = Module(type: .conjunction, lastPulse: [:], flipState: nil, destinations: dest)
    } else {
        fatalError()
    }
}

// fill in lastPulse from all destinations to each conjunction
for c in moduleConf.filter({$0.value.type == .conjunction}) {
    for sm in moduleConf.filter({$0.value.destinations.contains(c.key)}) {
        moduleConf[c.key]!.lastPulse![sm.key] = .low
    }
}

typealias Pulse = (source: String, dest: String, pulse: Pulses)

var pCount : [Pulses: Int] = [:]

for _ in 0..<1000 {
    var stack : Deque<Pulse> = []
    stack.append(("button", "broadcaster", .low))
    while stack.count > 0 {
        let p = stack.removeFirst()
        pCount[p.pulse, default: 0] += 1
        if p.dest == "output" || p.dest == "rx" {
            continue
        }
        var m = moduleConf[p.dest]!
        switch m.type {
        case .broadcaster:
            for d in m.destinations {
                stack.append((p.dest, d, p.pulse))
            }
        case .conjunction:
            moduleConf[p.dest]!.lastPulse![p.source]! = p.pulse
            var nextPulse : Pulses? = nil
            if moduleConf[p.dest]!.lastPulse!.allSatisfy({ $0.value == .high }) {
                nextPulse = .low
            } else {
                nextPulse = .high
            }
            for d in m.destinations {
                stack.append((p.dest, d, nextPulse!))
            }
        case .flipflop:
            if p.pulse == .high {
                continue
            }
            var nextPulse : Pulses? = nil
            if m.flipState == false {
                moduleConf[p.dest]!.flipState = true
                nextPulse = .high
            } else {
                moduleConf[p.dest]!.flipState = false
                nextPulse = .low
            }
            for d in m.destinations {
                stack.append((p.dest, d, nextPulse!))
            }
        }
    }
}

print(pCount.reduce(into: 1, { $0 *= $1.value }))
