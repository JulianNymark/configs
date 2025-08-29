#!/bin/zsh
output=""
for file in "$@"; do
  output+="//// $(basename "$file") ////\n"
  output+="$(cat "$file")$\n\n"
done
echo -n "$output" | pbcopy
