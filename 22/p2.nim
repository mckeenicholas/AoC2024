import strutils, tables, sets, sequtils

let lines = open("input.txt").readAll().splitLines().mapIt(parseInt(it))

const prune_num = 16777216

proc calc_secret(num: int): int =
    let n64 = num * 64
    let s1 = (num xor n64) mod prune_num

    let d32 = s1 div 32
    let s2 = (d32 xor s1) mod prune_num

    let n2048 = s2 * 2048
    let s3 = (n2048 xor s2) mod prune_num

    return s3

var sequences = initTable[seq[int], int]()

for num in lines:
    var output: seq[int] = @[num mod 10]
    var secret = num
    for _ in 0..<2000:
        secret = calc_secret(secret)
        output.add(secret mod 10)

    var diffs: seq[int]
    for i in 0..<output.len - 1:
        diffs.add(output[i + 1] - output[i])
    
    var visited = initHashSet[seq[int]]()

    for i in 0..<output.len - 4:
        let s = diffs[i..i + 3]
        if visited.contains(s):
            continue

        visited.incl(s)
        sequences[s] = sequences.getOrDefault(s, 0) + output[i + 4]

var mv = 0
for v in sequences.values:
    if v > mv:
        mv = v
        
echo mv