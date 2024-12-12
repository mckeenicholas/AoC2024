import 'dart:io';
import 'dart:collection';

class DefaultSetMap<K, V> {
  final Map<K, Set<V>> _map = {};

  Set<V> get(K key) {
    return _map.putIfAbsent(key, () => {});
  }

  Iterable<MapEntry<K, Set<V>>> get entries => _map.entries;

  Iterator<MapEntry<K, Set<V>>> get iterator => _map.entries.iterator;
}

List mapRegions(List<List<String>> grid) {
  final rows = grid.length;
  final cols = grid[0].length;
  final visited = <String>{};
  final regions = [];

  Set<String> bfs(int startR, int startC, String char) {
    final queue = Queue<List<int>>();
    queue.add([startR, startC]);
    final region = <String>{};

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      final r = current[0];
      final c = current[1];
      final key = '$r,$c';

      if (visited.contains(key)) continue;

      visited.add(key);
      region.add(key);

      const directions = [
        [-1, 0], [1, 0], [0, -1], [0, 1]
      ];

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
        final boundaries = [
          DefaultSetMap<double, double>(),
          DefaultSetMap<double, double>(),
          DefaultSetMap<double, double>(),
          DefaultSetMap<double, double>()
        ];
        regions.add([char, region, boundaries]);
      }
    }
  }

  return regions;
}

void mapSides(List<List<String>> grid, List regions) {
  const directions = [
    [-1, 0], [1, 0], [0, -1], [0, 1]
  ];

  for (final regionData in regions) {
    final char = regionData[0];
    final region = regionData[1] as Set<String>;
    final boundaries = regionData[2];

    for (final pos in region) {
      final parts = pos.split(',');
      final r = int.parse(parts[0]);
      final c = int.parse(parts[1]);

      for (var i = 0; i < directions.length; i++) {
        final dr = directions[i][0];
        final dc = directions[i][1];
        final nr = r + dr;
        final nc = c + dc;
        final sr = r + dr / 2;
        final sc = c + dc / 2;

        if (nr < 0 || nr >= grid.length || nc < 0 || nc >= grid[0].length ||
            grid[r][c] != grid[nr][nc]) {
          if (dr == 0) {
            if (dc == 1) {
              boundaries[0].get(sc).add(sr);
            } else {
              boundaries[1].get(sc).add(sr);
            }
          } else {
            if (dr == 1) {
              boundaries[2].get(sr).add(sc);
            } else {
              boundaries[3].get(sr).add(sc);
            }
          }
        }
      }
    }
  }
}

int countSides(List<DefaultSetMap<double, double>> boundaries) {
  var sides = 0;
  for (final direction in boundaries) {
    for (final entry in direction.entries) {
      final sortedPoints = entry.value.toList()..sort();
      for (var i = 0; i < sortedPoints.length; i++) {
        if (i + 1 >= sortedPoints.length ||
            sortedPoints[i] + 1 != sortedPoints[i + 1]) {
          sides++;
        }
      }
    }
  }
  return sides;
}

void main(List<String> args) {
  final input = File("input.txt").readAsStringSync();
  final grid = input.trim().split('\n').map((line) => line.trim().split('')).toList();
  final regions = mapRegions(grid);
  mapSides(grid, regions);

  var total = 0;
  for (final regionData in regions) {
    final region = regionData[1] as Set<String>;
    final boundaries = regionData[2] as List<DefaultSetMap<double, double>>;
    final sides = countSides(boundaries);
    total += sides * region.length;
  }

  print(total);
}