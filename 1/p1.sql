DROP TABLE IF EXISTS input;

CREATE TABLE input (
  id SERIAL PRIMARY KEY,
  val1 INTEGER,
  dummy1 TEXT,
  dummy2 TEXT,
  val2 INTEGER
);

\copy input (val1, dummy1, dummy2, val2) FROM './input.txt' WITH DELIMITER ' ';

WITH sorted_vals AS (
    SELECT 
        array(SELECT val1 FROM input ORDER BY val1) AS sorted_a,
        array(SELECT val2 FROM input ORDER BY val2) AS sorted_b
)
SELECT SUM(abs(sorted_a[i] - sorted_b[i])) AS total
FROM sorted_vals,
     generate_series(1, array_length(sorted_a, 1)) AS i;

WITH freq AS (
    SELECT val2, COUNT(*) AS c
    FROM input
    GROUP BY val2
),
calculation AS (
    SELECT i.val1, f.c
    FROM input i
    JOIN freq f
    ON i.val1 = f.val2
)
SELECT SUM(val1 * c) AS total
FROM calculation;
