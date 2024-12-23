import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class p2 {
    public static void main(String[] args) throws IOException {
        List<String> board = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader("input.txt"))) {
            String line;
            while ((line = br.readLine()) != null) {
                board.add(line.trim());
            }
        }

        int startRow = -1, startCol = -1;

        for (int r = 0; r < board.size(); r++) {
            for (int c = 0; c < board.get(r).length(); c++) {
                char ch = board.get(r).charAt(c);
                if (ch == 'S') {
                    startRow = r;
                    startCol = c;
                }
            }
        }

        int[][] visited = new int[board.size()][board.get(0).length()];
        for (int[] row : visited) {
            Arrays.fill(row, -1);
        }

        Deque<int[]> queue = new ArrayDeque<>();
        queue.add(new int[] { startRow, startCol });
        visited[startRow][startCol] = 0;

        int[][] directions = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } };

        while (!queue.isEmpty()) {
            int[] current = queue.poll();
            int r = current[0];
            int c = current[1];

            for (int[] dir : directions) {
                int newR = r + dir[0];
                int newC = c + dir[1];

                if (newR < 0 || newR >= board.size() || newC < 0 || newC >= board.get(0).length())
                    continue;

                if (board.get(newR).charAt(newC) == '#' || visited[newR][newC] != -1)
                    continue;

                visited[newR][newC] = visited[r][c] + 1;
                queue.add(new int[] { newR, newC });
            }
        }

        int count = 0;

        for (int r1 = 0; r1 < visited.length; r1++) {
            for (int c1 = 0; c1 < visited[r1].length; c1++) {
                int p1Dist = visited[r1][c1];
                if (p1Dist == -1) {
                    continue;
                }

                for (int r2 = 0; r2 < visited.length; r2++) {
                    for (int c2 = 0; c2 < visited[r2].length; c2++) {
                        int p2Dist = visited[r2][c2];
                        if (p2Dist == -1 || p1Dist >= p2Dist) {
                            continue;
                        }

                        int cheat_dist = Math.abs(r1 - r2) + Math.abs(c1 - c2);

                        if (cheat_dist > 20) {
                            continue;
                        }

                        int reduction = p2Dist - (p1Dist + cheat_dist);
                        if (reduction >= 100) {
                            count++;
                        }

                    }
                }
            }
        }

        System.out.println(count);
    }
}
