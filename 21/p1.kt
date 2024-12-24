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

fun testPath(location: Pair<Int, Int>, path: String, grid: Array<Array<Char>>): Boolean {
    var (cx, cy) = location
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

fun paths(location: Pair<Int, Int>, target: Pair<Int, Int>, grid: Array<Array<Char>>): List<String> {
    if (location == target) {
        return listOf("")
    }

    val (lx, ly) = location
    val (tx, ty) = target

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
    return combos.filter { testPath(location, it, grid) }
}

fun main() {
    var total = 0
    val inputLines = File("input.txt").readLines()

    for (line in inputLines) {
        var initLoc = numpadIndex['A']!!
        var accumulatedPaths = listOf("")

        for (char in line) {
            val target = numpadIndex[char]!!
            val shortestPaths = paths(initLoc, target, numpad)

            val newAccumulatedPaths = mutableListOf<String>()
            for (accPath in accumulatedPaths) {
                for (shortPath in shortestPaths) {
                    newAccumulatedPaths.add(accPath + shortPath + "A")
                }
            }

            accumulatedPaths = newAccumulatedPaths
            initLoc = target
        }

        val p2Paths = mutableListOf<String>()

        for (path in accumulatedPaths) {
            var init2 = dpadIndex['A']!!
            var subpaths = listOf("")

            for (char in path) {
                val target = dpadIndex[char]!!
                val shortestPaths = paths(init2, target, dpad)

                val newAccumulatedPaths = mutableListOf<String>()
                for (accPath in subpaths) {
                    for (shortPath in shortestPaths) {
                        newAccumulatedPaths.add(accPath + shortPath + 'A')
                    }
                }

                subpaths = newAccumulatedPaths
                init2 = target
            }

            p2Paths.addAll(subpaths)
        }

        val p3Paths = mutableListOf<String>()

        for (path in p2Paths) {
            var init3 = dpadIndex['A']!!
            var subpaths = listOf("")

            for (char in path) {
                val target = dpadIndex[char]!!
                val shortestPaths = paths(init3, target, dpad)

                val newAccumulatedPaths = mutableListOf<String>()
                for (accPath in subpaths) {
                    for (shortPath in shortestPaths) {
                        newAccumulatedPaths.add(accPath + shortPath + "A")
                    }
                }

                subpaths = newAccumulatedPaths
                init3 = target
            }

            p3Paths.addAll(subpaths)
        }

        val minLen = p3Paths.minOf { it.length }
        val num = line.dropLast(1).toInt()

        total += num * minLen
    }

    println(total)
}