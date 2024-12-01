#!/bin/bash
a=()
b=()

while IFS= read -r line || [[ -n $line ]]; do
    first=$(echo $line | awk '{print $1}')
    second=$(echo $line | awk '{print $2}')
    a+=($first)
    b+=($second)
done < input.txt

IFS=$'\n' a=($(printf "%s\n" "${a[@]}" | sort -n))
IFS=$'\n' b=($(printf "%s\n" "${b[@]}" | sort -n))

total=0

for i in "${!a[@]}"; do
    diff=$(( a[i] - b[i] ))
    total=$(( total + (diff < 0 ? -diff : diff) ))
done

echo $total
