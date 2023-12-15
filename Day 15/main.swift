//
//  main.swift
//  Day 15
//
//  Created by Scott Dier on 2023-12-15.
//

import Foundation
import OrderedCollections

let input = """
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
""".components(separatedBy: ",")

func d15hash(_ str: String) -> Int {
    let cArray = Array(str)
    var cValue = 0
    for char in cArray {
        let a = Int(char.asciiValue!)
        cValue += a
        cValue *= 17
        cValue %= 256
    }
    return cValue
}

var boxes : [Int: OrderedDictionary<String, Int>] = [:]

var total = 0
for str in input {
    let oHash = d15hash(str)
    total += oHash
    let opRegs = str.split(separator: /[=-]/)
    let op = str.firstMatch(of: /([=-])/)
    switch op!.0 {
    case "=":
        let label = String(opRegs[0])
        let length = Int(String(opRegs[1]))
        boxes[d15hash(label), default: [:]][label] = length
    case "-":
        let label = String(opRegs[0])
        let hash = d15hash(label)
        if boxes.keys.contains(d15hash(label)) {
            boxes[hash]!.removeValue(forKey: label)
            if boxes[hash]!.isEmpty {
                boxes.removeValue(forKey: hash)
            }
        }
    default:
        fatalError()
    }
}

print("operations checksum:", total)

var power = 0
for box in boxes {
    for (slotIdx, lens) in box.value.enumerated() {
        power += (box.key + 1) * (slotIdx + 1) * lens.value
    }
}

print(power)
