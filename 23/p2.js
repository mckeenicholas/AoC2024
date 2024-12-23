const fs = require("fs");

const fileContent = fs.readFileSync("input.txt", "utf-8");
const lines = fileContent.split("\n");

let graph = {};

lines.forEach((line) => {
  let [a, b] = line.split("-");

  if (!graph[a]) graph[a] = new Set();
  if (!graph[b]) graph[b] = new Set();

  graph[a].add(b);
  graph[b].add(a);
});

const nodes = Object.keys(graph);
let largestClique = [];

function findClique(R, P, X) {
  if (P.size === 0 && X.size === 0) {
    if (R.size > largestClique.length) {
      largestClique = Array.from(R);
    }
    return;
  }

  const pivot = P.size > 0 ? Array.from(P)[0] : null;
  const pivotNeighbors = pivot ? graph[pivot] : new Set();

  const candidates = Array.from(P).filter((node) => !pivotNeighbors.has(node));

  for (let v of candidates) {
    const neighbors = graph[v];
    findClique(
      new Set([...R, v]),
      new Set([...P].filter((n) => neighbors.has(n))),
      new Set([...X].filter((n) => neighbors.has(n))),
    );
    P.delete(v);
    X.add(v);
  }
}

findClique(new Set(), new Set(nodes), new Set());

const ans = largestClique.sort().join(",");
console.log(ans);
