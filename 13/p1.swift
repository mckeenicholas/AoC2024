import Foundation

struct Coord {
    var x: Int
    var y: Int
}

func parseLine(_ line: String) -> Coord {
    let pattern = #"\d+"#
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(line.startIndex..., in: line)
    let matches = regex.matches(in: line, range: range)
    
    let numbers = matches.compactMap { match -> Int? in
        let range = Range(match.range, in: line)!
        return Int(line[range])
    }
    
    return Coord(x: numbers[0], y: numbers[1])
}

let fileURL = URL(fileURLWithPath: "input.txt")

let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.split(whereSeparator: \.isNewline).map(String.init)

var index = 0
var cost = 0

while index < lines.count {
    let ALine = lines[index]
    let BLine = lines[index + 1]
    let PLine = lines[index + 2]
    
    let A = parseLine(ALine)
    let B = parseLine(BLine)
    let P = parseLine(PLine)

    var minCost = Int.max

    for a in 0...101 {
        let targetX = P.x - a * A.x
        let targetY = P.y - a * A.y
        
        if targetX % B.x == 0 && targetY % B.y == 0 {
            let b = targetX / B.x
            
            if b >= 0 && b * B.y == targetY {
                let cost = 3 * a + b
                minCost = min(minCost, cost)
            }
        }
    }

    if minCost != Int.max {
            cost += minCost
    }

    
    index += 3
}

print(cost)