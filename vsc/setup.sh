#!/usr/bin/env bash
set -euo pipefail

# this script will install vsc extensions

# code --list-extensions

declare -a arr=(
    "JPTarquino.postgresql"
    "PeterJausovec.vscode-docker"
    "geddski.macros"
    "hiro-sun.vscode-emacs"
    "jbw91.theme-material-dark-soda"
    "lukehoban.Go"
    "selbh.keyboard-scroll"
    )

for e in "${arr[@]}"
do
   code --install-extension "$e"
done
