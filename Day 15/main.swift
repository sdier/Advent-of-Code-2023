//
//  main.swift
//  Day 15
//
//  Created by Scott Dier on 2023-12-15.
//

import Foundation

let input = """
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
""".components(separatedBy: ",").map({Array($0)})

var total = 0
for str in input {
    var cValue = 0
    for char in str {
        let a = Int(char.asciiValue!)
        cValue += a
        cValue = cValue * 17
        cValue = cValue % 256
    }
    total += cValue
}

print(total)
