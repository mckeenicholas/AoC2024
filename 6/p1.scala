import scala.io.Source
import scala.collection.mutable

object Part1 {
  def main(args: Array[String]): Unit = {
    val lines = Source.fromFile("input.txt").getLines().toArray
    
    val (startX, startY) = findStart(lines)
    
    val dirs = Array((-1, 0), (0, 1), (1, 0), (0, -1))
    
    val visited = mutable.Set[(Int, Int)]()
    
    traverseGrid(lines, startX, startY, dirs, visited)
    
    println(visited.size)
  }
  
  def findStart(lines: Array[String]): (Int, Int) = {
    for {
      i <- lines.indices
      pos = lines(i).indexOf('^')
      if pos != -1
    } return (i, pos)
    
    return (-1, -1)
  }
  
  def traverseGrid(
    lines: Array[String], 
    startX: Int, 
    startY: Int, 
    dirs: Array[(Int, Int)], 
    visited: mutable.Set[(Int, Int)]
  ): Unit = {
    var x = startX
    var y = startY
    var dirIdx = 0
    
    def isValidPosition(x: Int, y: Int): Boolean = 
      x >= 0 && x < lines.length && y >= 0 && y < lines(0).length
    
    while (true) {
      val (dx, dy) = dirs(dirIdx)
      
      if (!isValidPosition(x, y)) {
        return
      }
      
      visited.add((x, y))
      
      val newX = x + dx
      val newY = y + dy
      
      if (!isValidPosition(newX, newY)) {
        return
      }
      
      if (lines(newX)(newY) == '#') {
        dirIdx = (dirIdx + 1) % 4
      } else {
        x = newX
        y = newY
      }
    }
  }
}