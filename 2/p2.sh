#!/bin/bash

safe() {
  local arr=("$@")
  local n=${#arr[@]}

  local inc=1
  local dec=1

  for ((i=1; i<n; i++)); do
    diff=$((arr[i] - arr[i-1]))

    if ((diff < 0)); then
        abs=$(( -diff ))
    else
        abs=$diff
    fi
    
    if ((diff > 0)); then
      dec=0
    elif ((diff < 0)); then
      inc=0
    fi

    if ((abs < 1 || abs > 3)); then
      return 1
    fi
  done
  
  if ((inc == 1 || dec == 1)); then
    return 0
  else
    return 1
  fi
}

almost_safe() {
  local arr=($1)
  local n=${#arr[@]}

  if safe "${arr[@]}"; then
    return 0
  fi

  for ((j=0; j<n; j++)); do
    new=("${arr[@]:0:j}" "${arr[@]:((j+1))}")

    if safe "${new[@]}"; then
      return 0
    fi

  done
  
  return 1
}

total=0

while IFS= read -r line || [[ -n $line ]]; do

  if almost_safe "$line"; then
    total=$((total + 1))
  fi
done < input.txt

echo $total 
