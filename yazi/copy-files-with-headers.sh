#!/bin/zsh

# Function to get relative path from git root or HOME
get_relative_path() {
    local file_path="$1"
    local abs_path=$(realpath "$file_path")

    # Try to find git root
    local git_root=$(git -C "$(dirname "$abs_path")" rev-parse --show-toplevel 2>/dev/null)

    if [[ -n "$git_root" ]]; then
        # Return path relative to git root
        echo "${abs_path#$git_root/}"
    else
        # Fall back to HOME relative path
        echo "${abs_path#$HOME/}"
    fi
}

output=""
for file in "$@"; do
  relative_path=$(get_relative_path "$file")
  output+="//// $relative_path ////\n"
  output+="$(cat "$file")\n\n"
done
echo -n "$output" | pbcopy
