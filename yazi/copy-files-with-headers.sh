#!/bin/zsh
output=""
for file in "$@"; do
  output+="//// $file ////\n"
  output+="$(cat "$file")$\n\n"
done
echo -n "$output" | pbcopy
