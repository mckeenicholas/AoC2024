#!/bin/bash
a=()

declare -A count

while IFS= read -r line || [[ -n $line ]]; do
    first=$(echo $line | awk '{print $1}')
    second=$(echo $line | awk '{print $2}')
    a+=($first)
    count[$second]=$((count[$second] + 1))
done < input.txt

total=0

for i in "${a[@]}"; do
    total=$((total + i * count["$i"]))
done

echo $total