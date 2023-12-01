//
//  main.swift
//  Day 1
//
//  Created by Scott Dier on 2023-12-02.
//

import Foundation

let input = """
""".components(separatedBy: "\n").map({Array(String($0))})

var calNums : [Int] = []

for chars in input {
    var firstSeen = false
    var firstNum : Character = " "
    var lastNum : Character = " "
    for char in chars {
        if char.isWholeNumber {
            if !firstSeen {
                firstNum = char
                firstSeen = true
            }
            lastNum = char
        }
    }
    var number = ""
    number.append(firstNum)
    number.append(lastNum)
    calNums.append(Int(number)!)
}

var calibration = 0

for calNum in calNums {
    calibration = calibration + calNum
}

print("calibration: ", calibration)
