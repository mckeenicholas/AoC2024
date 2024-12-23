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

let connected = new Set();

for (const node in graph) {
  let neighbors = Array.from(graph[node]);

  for (let i = 0; i < neighbors.length; i++) {
    for (let j = i + 1; j < neighbors.length; j++) {
      let a = neighbors[i];
      let b = neighbors[j];

      if (graph[a] && graph[a].has(b)) {
        connected.add([node, a, b].sort().join(","));
      }
    }
  }
}

const total = Array.from(connected).reduce((count, triangle) => {
  const components = triangle.split(",");
  return components.some((comp) => comp.startsWith("t")) ? count + 1 : count;
}, 0);

console.log(total);
