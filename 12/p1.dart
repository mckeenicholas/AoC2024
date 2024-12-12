import 'dart:io';
import 'dart:collection';

List<List<dynamic>> mapRegions(List<List<String>> grid) {
  final rows = grid.length;
  final cols = grid[0].length;
  final visited = HashSet<String>();
  final regions = <List<dynamic>>[];
  const directions = [
    [-1, 0], [1, 0], [0, -1], [0, 1]
  ];

  Set<String> bfs(int startR, int startC, String char) {
    final queue = Queue<List<int>>()..add([startR, startC]);
    final region = HashSet<String>();

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      final r = current[0];
      final c = current[1];
      final key = '$r,$c';

      if (visited.contains(key)) continue;

      visited.add(key);
      region.add(key);

      for (final direction in directions) {
        final nr = r + direction[0];
        final nc = c + direction[1];
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols &&
            grid[nr][nc] == char && !visited.contains('$nr,$nc')) {
          queue.add([nr, nc]);
        }
      }
    }
    return region;
  }

  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (!visited.contains('$r,$c')) {
        final char = grid[r][c];
        final region = bfs(r, c, char);
        regions.add([char, region, 0]);
      }
    }
  }

  return regions;
}

void findPerimiters(List<List<String>> grid, List<List<dynamic>> regions) {
  final directions = [
    [-1, 0], [1, 0], [0, -1], [0, 1]
  ];

  for (final item in regions) {
    final char = item[0];
    final region = item[1] as Set<String>;

    for (final pos in region) {
      final coordinates = pos.split(',').map(int.parse).toList();
      final r = coordinates[0];
      final c = coordinates[1];

      for (final direction in directions) {
        final nr = r + direction[0];
        final nc = c + direction[1];
        if (nr < 0 || nr >= grid.length || nc < 0 || nc >= grid[0].length ||
            grid[nr][nc] != char) {
          item[2] = item[2] + 1;
        }
      }
    }
  }
}


void main(List<String> args) {
  final input = File("input.txt").readAsStringSync();
  final grid = input.trim().split('\n').map((line) => line.trim().split('')).toList();
  final regions = mapRegions(grid);
  findPerimiters(grid, regions);

  var total = 0;
  for (final region in regions) {
    final perimeter = region[2] as int;
    final regionSize = (region[1] as Set).length;
    total += perimeter * regionSize;
  }

  print(total);
}