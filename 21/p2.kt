import java.io.File

val numpadIndex = mapOf(
    '7' to Pair(0, 0), '8' to Pair(0, 1), '9' to Pair(0, 2),
    '4' to Pair(1, 0), '5' to Pair(1, 1), '6' to Pair(1, 2),
    '1' to Pair(2, 0), '2' to Pair(2, 1), '3' to Pair(2, 2),
    '0' to Pair(3, 1), 'A' to Pair(3, 2)
)

val dpadIndex = mapOf(
    '^' to Pair(0, 1), 'A' to Pair(0, 2),
    '<' to Pair(1, 0), 'v' to Pair(1, 1), '>' to Pair(1, 2)
)

val dpad = arrayOf(
    arrayOf(' ', '^', '>'),
    arrayOf('<', 'v', '>')
)

val numpad = arrayOf(
    arrayOf('7', '8', '9'),
    arrayOf('4', '5', '6'),
    arrayOf('1', '2', '3'),
    arrayOf(' ', '0', 'A')
)

val dirs = mapOf(
    '>' to Pair(0, 1),
    '<' to Pair(0, -1),
    'v' to Pair(1, 0),
    '^' to Pair(-1, 0)
)

const val maxDepth = 25

var cache = hashMapOf<String, Long>()

fun testPath(cur: Char, path: String, isNumpad: Boolean): Boolean {
    val grid = if (isNumpad) numpad else dpad;
    val index = if (isNumpad) numpadIndex else dpadIndex

    var (cx, cy) = index[cur]!!
    for (move in path) {
        val (dx, dy) = dirs[move]!!
        cx += dx
        cy += dy
        if (grid[cx][cy] == ' ') {
            return false
        }
    }
    return true
}

fun generatePermutations(str: String): Set<String> {
    if (str.length <= 1) return setOf(str)
    val result = mutableSetOf<String>()
    for (i in str.indices) {
        val char = str[i]
        val remainingChars = str.substring(0, i) + str.substring(i + 1)
        for (perm in generatePermutations(remainingChars)) {
            result.add(char + perm)
        }
    }
    return result
}

fun paths(cur: Char, target: Char, isNumpad: Boolean): List<String> {
    val index = if (isNumpad) numpadIndex else dpadIndex

    if (cur == target) {
        return listOf("A")
    }

    val (lx, ly) = index[cur]!!
    val (tx, ty) = index[target]!!

    val dx = tx - lx
    val dy = ty - ly

    var moves = ""
    if (dx > 0) {
        moves += "v".repeat(dx)
    } else if (dx < 0) {
        moves += "^".repeat(-dx)
    }

    if (dy > 0) {
        moves += ">".repeat(dy)
    } else if (dy < 0) {
        moves += "<".repeat(-dy)
    }

    val combos = generatePermutations(moves)
    return combos.filter { testPath(cur, it, isNumpad) }.map { it + "A" }
}

fun getOptimal(start: Char, end: Char, depth: Int): Long {
    val cacheKey = start.toString() + end.toString() + depth.toString()
    if (cache.containsKey(cacheKey)) {
        return cache[cacheKey]!!
    }

    val possiblePaths = paths(start, end, depth == maxDepth)
    if (depth == 0) return possiblePaths[0].length.toLong()

    var minLen = Long.MAX_VALUE

    for (path in possiblePaths) {
        var total: Long = 0
        var cur = 'A'

        for (step in path) {
            total += getOptimal(cur, step, depth - 1)
            cur = step
        }

        minLen = Math.min(minLen, total)
    }

    cache[cacheKey] = minLen
    return minLen
}

fun main() {
    var total: Long = 0
    val inputLines = File("input.txt").readLines()

    for (line in inputLines) {
        var cur = 'A'
        var pathLen: Long = 0

        for (step in line) {
            pathLen += getOptimal(cur, step, maxDepth)
            cur = step
        }

        val num = line.dropLast(1).toInt()
        total += pathLen * num
    }

    println(total)
}