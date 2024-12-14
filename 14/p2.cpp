#include <array>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

struct Bot {
  int x;
  int y;
  int dx;
  int dy;
};

constexpr int maxX = 101;
constexpr int maxY = 103;

int main() {
  std::vector<Bot> bots;
  std::string line;

  std::ifstream inputFile("input.txt");

  while (std::getline(inputFile, line)) {
    Bot point;
    char dummy;
    std::istringstream iss(line);

    iss >> dummy >> dummy >> point.x >> dummy >> point.y >> dummy >> dummy >>
        point.dx >> dummy >> point.dy;

    bots.push_back(point);
  }
  for (int i = 0; i < 1e5; i++) {
    std::array<std::array<char, maxX>, maxY> grid;
    grid.fill(std::array<char, maxX>());
    for (auto &row : grid) {
      row.fill('.');
    }

    bool distinct = true;

    for (auto &[x, y, dx, dy] : bots) {
      x += dx;
      y += dy;

      if (x < 0) {
        x += maxX;
      } else if (x >= maxX) {
        x -= maxX;
      }

      if (y < 0) {
        y += maxY;
      } else if (y >= maxY) {
        y -= maxY;
      }

      if (grid[y][x] == '.') {
        grid[y][x] = '#';
      } else {
        distinct = false;
      }
    }

    if (distinct) {
      std::cout << "\nIter: " << i + 1 << "\n";
      for (const auto &r : grid) {
        for (const auto &c : r) {
          std::cout << c;
        }
        std::cout << "\n";
      }
    }
  }

  return 0;
}
