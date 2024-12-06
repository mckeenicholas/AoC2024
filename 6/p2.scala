import scala.io.Source
import scala.collection.mutable

object Part2 {
  def main(args: Array[String]): Unit = {
    val lines = Source.fromFile("input.txt").getLines().toArray
    val grid = lines.map(_.toArray)
    
    val (startX, startY) = findStart(grid)
    val dirs = Array((-1, 0), (0, 1), (1, 0), (0, -1))

    var count = 0

    for {
      i <- grid.indices
      j <- grid(i).indices
      if grid(i)(j) == '.'
    } {
      val gridCopy = grid.map(_.clone())
      gridCopy(i)(j) = '#'
      
      if (traverseGrid(gridCopy, startX, startY, dirs)) {
        count += 1
      }
    }

    println(count)
  }
  
  def findStart(grid: Array[Array[Char]]): (Int, Int) = {
    for {
      i <- grid.indices
      j <- grid(i).indices
      if grid(i)(j) == '^'
    } return (i, j)
    
    (-1, -1)
  }
  
  def countValidConfigurations(
    originalGrid: Array[Array[Char]], 
    startX: Int, 
    startY: Int,
    dirs: Array[(Int, Int)]
  ): Int = {
    var count = 0
    
    
    
    count
  }
  
def traverseGrid(
  grid: Array[Array[Char]], 
  startX: Int, 
  startY: Int, 
  dirs: Array[(Int, Int)]
): Boolean = {
  val visited = mutable.Set[(Int, Int, Int)]()

  var x = startX
  var y = startY
  var dirIdx = 0
  
  def isValidPosition(x: Int, y: Int): Boolean = 
    x >= 0 && x < grid.length && y >= 0 && y < grid(0).length

  while (true) {
    if (visited.contains((x, y, dirIdx))) {
      return true
    }

    val (dx, dy) = dirs(dirIdx)

    if (!isValidPosition(x, y)) {
      return false
    }

    visited.add((x, y, dirIdx))

    val newX = x + dx
    val newY = y + dy

    if (!isValidPosition(newX, newY)) {
      return false
    }

    if (grid(newX)(newY) == '#') {
      dirIdx = (dirIdx + 1) % 4
    } else {
      x = newX
      y = newY
    }
  }
  false
}

}