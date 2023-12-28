//
//  main.swift
//  Day 21
//
//  Created by Scott Dier on 2023-12-23.
//

import Foundation
import MemoZ

let input = """
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
""".components(separatedBy: .newlines).map({Array($0)})

typealias Coordinate = (x: Int, y: Int)

/*
enum Directions: Int {
    case up
    case right
    case down
    case left
}

let directions : [Directions : Coordinate] = [
    .up : (x: 0, y:-1),
    .right : (x: 1, y:0),
    .down : (x: 0, y:1),
    .left : (x: -1, y:0)]
 */

var readyMap = input
var origin : Coordinate? = nil
for (lineY, line) in input.enumerated() {
    for (rowX, char) in line.enumerated() {
        if char == "S" {
            readyMap[lineY][rowX] = "O"
            origin = (x: rowX, y: lineY)
        }
    }
}

/*
typealias GardenMap = [[Character]]

extension GardenMap {
    init(map: [[Character]]) {
        // add border
        var m = map
        for i in 0..<map.count {
            m[i].insert(".", at: 0)
            m[i].append(".")
        }
        m.insert(m[0], at: 0)
        m.append(m[m.count - 1])
        self.init(m)
    }
    var nextGen: GardenMap {
        // generate next map including border
        var newmap = self
        for (lineY, line) in self.enumerated() {
            for (rowX, char) in line.enumerated() {
                if char == "O" {
                    newmap[lineY][rowX] = "."
                    for (_, direction) in directions {
                        let newX = rowX + direction.x
                        let newY = lineY + direction.y
                        if newX < 0 || newY < 0 || newY >= self.count || newX >= self[0].count {
                            continue
                        }
                        if (self[newY][newX] != "#") {
                            newmap[newY][newX] = "O"
                        }
                    }
                }
            }
        }
        return newmap
    }
    var nextGenZ : GardenMap {
        // memoize generation
        self.memoz.nextGen
    }
    var nextMap : [[Character]] {
        // Remove border then return
        var m = self.nextGenZ
        _ = m.removeFirst()
        _ = m.removeLast()
        for i in 0..<m.count {
            _ = m[i].removeFirst()
            _ = m[i].removeLast()
        }
        return m
    }
    var nextMapZ : [[Character]] {
        self.memoz.nextMap
    }
    var curMap : [[Character]] {
        // Remove border then return
        var m = self
        _ = m.removeFirst()
        _ = m.removeLast()
        for i in 0..<m.count {
            _ = m[i].removeFirst()
            _ = m[i].removeLast()
        }
        return m
    }
    var curMapZ : [[Character]] {
        self.memoz.curMap
    }
    var nextReachable : Int {
        return self.nextMapZ.reduce(into: 0, { $0 += $1.reduce(into: 0, {
            if $1 == "O" {
                $0 += 1
            }
        })})
    }
    var nextReachableZ : Int {
        self.memoz.reachable
    }
    var reachable : Int {
        return self.nextMapZ.reduce(into: 0, { $0 += $1.reduce(into: 0, {
            if $1 == "O" {
                $0 += 1
            }
        })})
    }
    var reachableZ : Int {
        self.memoz.reachable
    }
    subscript(dir: Directions) -> [Coordinate] {
        // return list of coordinates to apply to neigboring map in direction by looking at border
        return []
    }
} */

// https://johnhw.github.io/hashlife/index.md.html
class Node : Hashable {
    init(k: Int? = nil, a: Node? = nil, b: Node? = nil, c: Node? = nil, d: Node? = nil, n: Int? = nil, x: Int? = nil, y: Int? = nil) {
        // TODO: wrap and memoize for join case.  Change calls to use memoizer for join.
        self.a = a
        self.b = b
        self.c = c
        self.d = d

        if a != nil, b != nil, c != nil, d != nil {
            guard [b!.k, c!.k, d!.k].allSatisfy( { $0! == a!.k! }) else {
                fatalError()
            }

            let scale = Int(truncating: pow(Decimal(2), a!.k!) as NSDecimalNumber)

            let axbx =  (a!.x + scale) % input[0].count == b!.x
            let ayby =  a!.y == b!.y
            let axcx =  a!.x == c!.x
            let aycy = (a!.y + scale) % input.count == c!.y
            let axdx = (a!.x + scale) % input[0].count == d!.x
            let aydy = (a!.y + scale) % input.count == d!.y

            guard [axbx, ayby, axcx, aycy, axdx, aydy].allSatisfy(({$0 == true})) else {
                fatalError()
            }

            self.aHash = a!.hashValue
            self.bHash = b!.hashValue
            self.cHash = c!.hashValue
            self.dHash = d!.hashValue
        }

        if k != nil {
            self.k = k
        } else if self.a != nil && self.b != nil && self.c != nil && self.d != nil {
            self.k = self.a!.k! + 1
        }

        if n != nil {
            self.n = n
        } else if self.a != nil && self.b != nil && self.c != nil && self.d != nil {
            self.n = a!.n! + b!.n! + c!.n! + d!.n!
        }

        // always map down to base map
        // This is always the upper-most-left (a-a-a-a...) coordinate
        // either a coordinate must be set at k=0
        // or all levels below must have coordinates set
        if x != nil && y != nil {
            self.x = x! % input[0].count
            self.y = y! % input.count
        } else {
            self.x = a!.x % input[0].count
            self.y = a!.y % input.count
        }
        if self.x < 0 {
            self.x = input[0].count + self.x
        }
        if self.y < 0 {
            self.y = input.count + self.y
        }

    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.aHash == rhs.aHash
        && lhs.bHash == rhs.bHash
        && lhs.cHash == rhs.cHash
        && lhs.dHash == rhs.dHash
        && lhs.k == rhs.k
        && lhs.n == rhs.n
        && lhs.x == rhs.x
        && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(aHash)
        hasher.combine(bHash)
        hasher.combine(cHash)
        hasher.combine(dHash)
        hasher.combine(k)
        hasher.combine(n)
        hasher.combine(x)
        hasher.combine(y)
    }

    var k: Int? = nil
    var a : Node? = nil
    var aHash : Int? = nil
    var b : Node? = nil
    var bHash : Int? = nil
    var c : Node? = nil
    var cHash : Int? = nil
    var d : Node? = nil
    var dHash : Int? = nil
    var n : Int? = nil

    var x : Int
    var y : Int

    func successor(_ J: Int? = nil) -> Node {
        func op(m: Node, J: Int? = nil) -> Node {
            var s : Node? = nil
            if m.n == 0 {
                return node(a: m.a!.d!, b: m.b!.c!, c: m.c!.b!, d: m.d!.a!)
            } else if m.k == 2 {
                // base case
                s = walk_4x4(m: m)
            } else {
                var j = m.k! - 2
                if J != nil {
                    j = min(J!, m.k! - 2)
                }
                let c1 = node(a: m.a!.a!, b: m.a!.b!, c: m.a!.c!, d: m.a!.d!).successor(j)
                let c2 = node(a: m.a!.b!, b: m.b!.a!, c: m.a!.d!, d: m.b!.c!).successor(j)
                let c3 = node(a: m.b!.a!, b: m.b!.b!, c: m.b!.c!, d: m.b!.d!).successor(j)
                let c4 = node(a: m.a!.c!, b: m.a!.d!, c: m.c!.a!, d: m.c!.b!).successor(j)
                let c5 = node(a: m.a!.d!, b: m.b!.c!, c: m.c!.b!, d: m.d!.a!).successor(j)
                let c6 = node(a: m.b!.c!, b: m.b!.d!, c: m.d!.a!, d: m.d!.b!).successor(j)
                let c7 = node(a: m.c!.a!, b: m.c!.b!, c: m.c!.c!, d: m.c!.d!).successor(j)
                let c8 = node(a: m.c!.b!, b: m.d!.a!, c: m.c!.d!, d: m.d!.c!).successor(j)
                let c9 = node(a: m.d!.a!, b: m.d!.b!, c: m.d!.c!, d: m.d!.d!).successor(j)

                if j < m.k! - 2 {
                    s = join(
                        a: join(a: c1.d!, b: c2.c!, c: c4.b!, d: c5.a!),
                        b: join(a: c2.d!, b: c3.c!, c: c5.b!, d: c6.a!),
                        c: join(a: c4.d!, b: c5.c!, c: c7.b!, d: c8.a!),
                        d: join(a: c5.d!, b: c6.c!, c: c8.b!, d: c9.a!))
                } else {
                    s = node(
                        a: node(a: c1, b: c2, c: c4, d: c5).successor(j),
                        b: node(a: c2, b: c3, c: c5, d: c6).successor(j),
                        c: node(a: c4, b: c5, c: c7, d: c8).successor(j),
                        d: node(a: c5, b: c6, c: c8, d: c9).successor(j))
                }
            }
            return s!
        }

        struct S : Hashable {
            let m : Node, J: Int?
            var s: Node { op(m: m, J: J) }
        }

        return S(m: self, J: J).memoz.s
    }

    func advance(N: Int) -> Node {
        if N == 0 {
            return self
        }

        var n = N
        var node : Node = self
        var bits : [Int] = []
        while n > 0 {
            bits.append(n & 1)
            n = n >> 1
            node = center(node)
            node = center(node)
        }

        for (k, bit) in bits.reversed().enumerated() {
            let j = bits.count - k - 1
            if bit == 1 {
                print("run", j)
                node = node.successor(j)
            }
        }
        return node
    }
}

func node(a: Node, b: Node, c: Node, d: Node) -> Node {
    func op(a: Node, b: Node, c: Node, d: Node) -> Node {
        return Node(a: a, b: b, c: c, d: d)
    }

    struct C : Hashable {
        let a, b, c, d: Node
        var f: Node { op(a: a, b: b, c: c, d: d)}
    }

    return C(a: a, b: b, c: c, d: d).memoz.f
}

func join(a: Node, b: Node, c: Node, d: Node) -> Node {
    func op(a: Node, b: Node, c: Node, d: Node) -> Node {
        guard [b.k, c.k, d.k].allSatisfy( { $0! == a.k! }) else {
            fatalError()
        }

        let scale = Int(truncating: pow(Decimal(2), a.k!) as NSDecimalNumber)

        let axbx =  (a.x + scale) % input[0].count == b.x
        let ayby =  a.y == b.y
        let axcx =  a.x == c.x
        let aycy = (a.y + scale) % input.count == c.y
        let axdx = (a.x + scale) % input[0].count == d.x
        let aydy = (a.y + scale) % input.count == d.y

        guard [axbx, ayby, axcx, aycy, axdx, aydy].allSatisfy(({$0 == true})) else {
            fatalError()
        }

        return Node(a: a, b: b, c: c, d: d)
    }

    struct C : Hashable {
        let a, b, c, d: Node
        var f: Node { op(a: a, b: b, c: c, d: d) }
    }

    return C(a: a, b: b, c: c, d: d).memoz.f
}

func getZero(_ k: Int, x: Int , y: Int) -> Node {
    func op(_ k: Int, x: Int, y: Int) -> Node {
        if k == 0 {
            return Node(k: 0, n: 0, x: x, y: y)
        } else {
            // scale given coordiantes down by k to getZero()
            let scale = Int(truncating: pow(Decimal(2), k - 1) as NSDecimalNumber)
            return join(
                a: getZero(k-1, x: x, y: y),
                b: getZero(k-1, x: x + scale, y: y),
                c: getZero(k-1, x: x, y: y + scale),
                d: getZero(k-1, x: x + scale, y: y + scale))
        }
    }

    struct C : Hashable {
        let k, x, y : Int
        var c: Node { op(k, x: x, y: y) }
    }

    var nx = x % input[0].count
    var ny = y % input.count

    if nx < 0 {
        nx = input[0].count + nx
    }
    if ny < 0 {
        ny = input.count + ny
    }

    return C(k: k, x: nx, y: ny).memoz.c
}

func center(_ m: Node) -> Node {
    // scale given coordinates by 2^(n-1-1)  (extra 1 is because we're working one level down)
    // its 2023 and look at this api for decimal -> int conversion, wtf.
    // if we need more than 2^63 this all has to be changed
    let scale = Int(truncating: pow(Decimal(2), m.k! - 1) as NSDecimalNumber)
    return join(
        a: join(
            a: getZero(m.k! - 1,
                       x: m.a!.x - scale,
                       y: m.a!.y - scale),
            b: getZero(m.k! - 1,
                       x: m.a!.x,
                       y: m.a!.y - scale),
            c: getZero(m.k! - 1,
                       x: m.a!.x - scale,
                       y: m.a!.y),
            d: m.a!),
        b: join(
            a: getZero(m.k! - 1,
                       x: m.b!.x,
                       y: m.b!.y - scale),
            b: getZero(m.k! - 1,
                       x: m.b!.x + scale,
                       y: m.b!.y - scale),
            c: m.b!,
            d: getZero(m.k! - 1,
                       x: m.b!.x + scale,
                       y: m.b!.y)),
        c: join(
            a: getZero(m.k! - 1,
                       x: m.c!.x - scale,
                       y: m.c!.y),
            b: m.c!,
            c: getZero(m.k! - 1,
                       x: m.c!.x - scale,
                       y: m.c!.y + scale),
            d: getZero(m.k! - 1,
                       x: m.c!.x,
                       y: m.c!.y + scale)),
        d: join(
            a: m.d!,
            b: getZero(m.k! - 1,
                       x: m.d!.x + scale,
                       y: m.d!.y),
            c: getZero(m.k! - 1,
                       x: m.d!.x,
                       y: m.d!.y + scale),
            d: getZero(m.k! - 1,
                       x: m.d!.x + scale,
                       y: m.d!.y + scale))
    )
}

func walk(b: Node, d: Node, E: Node, f: Node, h: Node) -> Node {

    /*
    let bx = E.x == b.x
    let by = E.y - b.y == 1
    let dx = E.x - d.x == 1
    let dy = E.y == d.y
    let fx = f.x - E.x == 1
    let fy = f.y == E.y
    let hx = h.x == E.x
    let hy = h.y - E.y == 1

    guard [bx, by, dx, dy, fx, fy, hx, hy].allSatisfy({$0 == true}) else {
        print("(", b.x, b.y,") (", d.x, d.y, ") (", E.x, E.y, ") (",f.x, f.y, ") (", h.x, h.y, ")")
        fatalError()
    }
     */

    if input[E.y][E.x] == "#" {
        // Am a rock
        return Node(k: 0, n: 0, x: E.x, y: E.y)
    }
    // Should this node become reachable or unreachable?
    if b.n == 1 || d.n == 1 || f.n == 1 || h.n == 1 {
        return Node(k:0, n:1, x: E.x, y: E.y)
    }
    // Not reachable
    return Node(k: 0, n: 0, x: E.x, y: E.y)
}

func walk_4x4(m: Node) -> Node {
    let ad = walk(b: m.a!.b!, d: m.a!.c!, E: m.a!.d!, f: m.b!.c!, h: m.c!.b! )
    let bc = walk(b: m.b!.a!, d: m.a!.d!, E: m.b!.c!, f: m.b!.d!, h: m.d!.a! )
    let cb = walk(b: m.a!.d!, d: m.c!.a!, E: m.c!.b!, f: m.d!.a!, h: m.c!.d! )
    let da = walk(b: m.b!.c!, d: m.c!.b!, E: m.d!.a!, f: m.d!.b!, h: m.d!.c! )

    return join(a: ad, b: bc, c: cb, d: da)
}

func expand(node: Node, level: Int = 0) -> [(Coordinate, Decimal)] {
    if node.n == 0 {
        return []
    }


    if node.k == level {
        let gray = Decimal(node.n!) / pow(pow(2, node.k!), 2)
        return [((node.x , node.y), gray)]
    } else {
        return (expand(node: node.a!, level: level)
                + expand(node: node.b!, level: level)
                + expand(node: node.c!, level: level)
                + expand(node: node.d!, level: level))
    }
}

var cur = center(center(join(
                      a: Node(k: 0, n: 1, x: origin!.x, y: origin!.y),
                      b: Node(k: 0, n: 0, x: origin!.x + 1, y: origin!.y),
                      c: Node(k: 0, n: 0, x: origin!.x, y: origin!.y + 1),
                      d: Node(k: 0, n: 0, x: origin!.x + 1, y: origin!.y + 1))))

// TODO: debug runtime efficiency -- 

/*
var i = 0
var steps = 5000
cur = center(cur)
while i < steps {
    cur = cur.advance(N: 1)
    if i % 32 == 0 {
        cur = center(cur)
    }
    i += 1
}
print (i, cur.n!)
 */
// last attempt k = 54
// add up to 62?

cur = center(cur)
cur = cur.advance(N: 26501365)
print(cur.n!)

