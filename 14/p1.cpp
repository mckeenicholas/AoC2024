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

  for (int i = 0; i < 100; i++) {
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
    }
  }

  int q1 = 0;
  int q2 = 0;
  int q3 = 0;
  int q4 = 0;

  for (const auto &[x, y, dx, dy] : bots) {
    if (x < maxX / 2 && y < maxY / 2)
      q1++;
    if (x > maxX / 2 && y < maxY / 2)
      q2++;
    if (x < maxX / 2 && y > maxY / 2)
      q3++;
    if (x > maxX / 2 && y > maxY / 2)
      q4++;
  }

  int out = q1 * q2 * q3 * q4;

  std::cout << out << "\n";
  return 0;
}
