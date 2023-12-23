//
//  main.swift
//  Day 20
//
//  Created by Scott Dier on 2023-12-21.
//

import Foundation
import DequeModule

let input = """
&zq -> fd, gk, pp, ph, ss, dr, pl
%qg -> jh, nk
%lm -> lg, qm
%fk -> lr
%pp -> hh
%bf -> sj, qm
&qm -> kb, jl, bs, kx, bl, cz, dd
%db -> dc, jn
%kl -> dc, qv
%xm -> jh
%ss -> zq, nd
%vq -> bh, dc
%bl -> bs
%fd -> gk
&dc -> tx, vq, ct, df, fx
%dj -> zq, pp
%fv -> vj, zq
%pv -> lm, qm
%dg -> zz, jh
%fc -> fk
%qv -> dc, db
&ls -> rx
&tx -> ls
%vl -> fc
%dr -> fd
&dd -> ls
%kx -> jl
%sj -> qm, bl
%vj -> zq
%nk -> jh, vl
%xr -> kr, jh
&nz -> ls
%cz -> bf
%ms -> qm
%ct -> fx
%lg -> qm, ms
%lr -> dg
%pl -> dr
%rt -> zq, dj
%jn -> dc
%zz -> zm
%kf -> kl, dc
%jl -> cz
%hh -> fv, zq
%df -> mr
&jh -> zz, lr, vl, fc, nz, fk, qg
%fx -> hq
%hq -> df, dc
%kb -> qm, kx
&ph -> ls
broadcaster -> kb, vq, ss, qg
%nd -> pl, zq
%gk -> rt
%mr -> dc, kf
%bs -> pv
%bh -> dc, ct
%kr -> jh, xm
%zm -> xr, jh
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
var i = 0
var seen : [String] = []

for i in 0..<30000 {
    //while true {
    if i % 500000 == 0 {
        print("up to iter", i)
    }
    var conjLowCount : [String: Int] = [:]
    var conjHighCount : [String: Int] = [:]
    var dModule : [Pulses: Int] = [:]
    var pArr : [Pulse] = [("button", "broadcaster", .low)]
    while pArr.count > 0 {
        var nArr : [Pulse] = []
        for p in pArr {
            pCount[p.pulse, default: 0] += 1
            if p.dest == "output" || p.dest == "rx" {
                dModule[p.pulse, default: 0] += 1
                continue
            }
            let m = moduleConf[p.dest]!
            switch m.type {
            case .broadcaster:
                for d in m.destinations {
                    nArr.append((p.dest, d, p.pulse))
                }
            case .conjunction:
                moduleConf[p.dest]!.lastPulse![p.source]! = p.pulse
                var nextPulse : Pulses? = nil
                if moduleConf[p.dest]!.lastPulse!.allSatisfy({ $0.value == .high }) {
                    conjLowCount[p.dest, default: 0] += 1
                    nextPulse = .low
                } else {
                    conjHighCount[p.dest, default: 0] += 1
                    nextPulse = .high
                }
                for d in m.destinations {
                    nArr.append((p.dest, d, nextPulse!))
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
                    nArr.append((p.dest, d, nextPulse!))
                }
            }
        }
        pArr = nArr
    }
    /*
    var mods : [String] = []
    var num = ""
    for mod in ["jn","db","qv","kl","kf","mr","hq","bh","vq"] {
        switch moduleConf[mod]!.flipState! {
        case true:
            num += "1"
        case false:
            num += "0"
        }
    }
    let dcNum = Int(num, radix: 2)!
    if dcNum == 0 {
        print (i, "dcnum 0")
        print(moduleConf["ct"]!.flipState!)
        print(moduleConf["df"]!.flipState!)
        print(moduleConf["fx"]!.flipState!)
        print(conjLowCount)
        print(conjHighCount)
    }
    for mod in moduleConf["dc"]!.lastPulse!.keys {
        //toPrint += mod + " " String(moduleConf[mod]!.flipState!) + " "
        if moduleConf[mod]!.flipState! {
            mods.append(mod)
        }
    }
    if mods.count == 1 && !seen.contains(mods[0]) {
        print(i, mods.count, mods[0])
        seen.append(mods[0])
    } */
    let checkme = "dd"
    if conjHighCount[checkme] == 1 {
        print(i, "high")
    } else if conjLowCount[checkme] == 1 {
        print(i, "low")
    } else {
        print(i, "none")
    }
    if dModule[.high, default: 0] == 1 {
        print("q", i, dModule[.low, default: 0], dModule[.high, default: 0])
    }
    if dModule[.low, default: 0] == 1 || dModule[.high, default: 0] == 0 {
        print("l", i, dModule[.low, default: 0], dModule[.high, default: 0])
    }
    if dModule[.low, default: 0] == 1 && dModule[.high, default: 0] == 0 {
        print("iter", i)
        break
    }
    //i += 1
}

