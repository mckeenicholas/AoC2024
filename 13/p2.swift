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
    let low = parseLine(PLine)
    let P = Coord(x: low.x + 10000000000000, y: low.y + 10000000000000)

    let a = (P.x * B.y - P.y * B.x) / (B.y * A.x - B.x * A.y)
    let b = (P.x * A.y - P.y * A.x) / (A.y * B.x - B.y * A.x)

    if A.x * a + B.x * b == P.x && A.y * a + B.y * b == P.y {
        cost += 3 * a + b
    }
    
    index += 3
}

print(cost)