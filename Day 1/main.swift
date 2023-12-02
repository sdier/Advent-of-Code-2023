//
//  main.swift
//  Day 1
//
//  Created by Scott Dier on 2023-12-02.
//

import Foundation

let input = """
""".components(separatedBy: "\n")

var numMap : [Character : [(numStr: String, numChar: Character)]] = [
    "o": [("one", "1")],
    "t": [("two", "2"), ("three", "3")],
    "f": [("four", "4"), ("five", "5")],
    "s": [("six", "6"), ("seven", "7")],
    "e": [("eight", "8")],
    "n": [("nine", "9")],
]

var calNums : [Int] = []

for line in input {
    print ("next line", line)
    let chars = Array(line)
    var firstSeen = false
    var firstNum : Character? = nil
    var lastNum : Character? = nil
    var pos = 0
    while pos < chars.count {
        print("pos",pos,"char",chars[pos])
        var number : Character? = nil
    charSwitch: switch chars[pos] {
        case let thisChar where thisChar.isWholeNumber:
            print("is number", thisChar)
            number = thisChar
            pos += 1
        case let thisChar where numMap.keys.contains(thisChar):
            for numWord in numMap[thisChar]! {
                print("check word", numWord.numStr)
                if numWord.numStr.count <= chars.count - pos && String(chars[pos..<pos+numWord.numStr.count]) == numWord.numStr {
                    print("found word", numWord.numChar)
                    number = numWord.numChar
                    pos += 1
                    break charSwitch
                }
            }
            pos += 1
            continue
        default:
            print("add 1")
            pos += 1
            continue
        }
        if !firstSeen {
            firstNum = number!
            firstSeen = true
        }
        lastNum = number!
    }
    var number = ""
    number.append(firstNum!)
    number.append(lastNum!)
    calNums.append(Int(number)!)
}

var calibration = 0

for calNum in calNums {
    print(calNum)
    calibration = calibration + calNum
}

print("calibration: ", calibration)
