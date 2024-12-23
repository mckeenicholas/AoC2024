import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class p1 {
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

        Deque<int[]> queue = new ArrayDeque<>();
        queue.add(new int[] { startRow, startCol });
        Map<String, Integer> visited = new HashMap<>();
        visited.put(startRow + "," + startCol, 0);

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

                if (board.get(newR).charAt(newC) == '#' || visited.containsKey(newR + "," + newC))
                    continue;

                visited.put(newR + "," + newC, visited.get(r + "," + c) + 1);
                queue.add(new int[] { newR, newC });
            }
        }

        List<Integer> cheatReductions = new ArrayList<>();
        int[][] cheatDirections = { { 2, 0 }, { 0, 2 }, { -2, 0 }, { 0, -2 } };

        for (Map.Entry<String, Integer> entry : visited.entrySet()) {
            String[] parts = entry.getKey().split(",");
            int r = Integer.parseInt(parts[0]);
            int c = Integer.parseInt(parts[1]);
            int cost = entry.getValue();

            for (int[] dir : cheatDirections) {
                int newR = r + dir[0];
                int newC = c + dir[1];

                if (newR < 0 || newR >= board.size() || newC < 0 || newC >= board.get(0).length())
                    continue;

                String newPos = newR + "," + newC;
                if (!visited.containsKey(newPos))
                    continue;

                int origDist = visited.get(newPos);
                int cheatReduction = origDist - (cost + 2);
                if (cheatReduction > 0) {
                    cheatReductions.add(cheatReduction);
                }
            }
        }

        int total = 0;
        for (int cheat : cheatReductions) {
            if (cheat >= 100) {
                total++;
            }
        }

        System.out.println(total);
    }
}
