import strutils, sequtils

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

var total = 0
for num in lines:
    var secret = num
    for _ in 0..<2000:
        secret = calc_secret(secret)
    
    total += secret

echo total
