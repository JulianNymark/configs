#!/usr/bin/env bash
set -euo pipefail

# this script will:
# 1. try to install vsc extensions
# 2. copy keybindings.json & settings.json into your user preferences

############################
# try to install extentions
############################

declare -a arr=(
    "EditorConfig.editorconfig"
    "JPTarquino.postgresql"
    "PeterJausovec.vscode-docker"
    "geddski.macros"
    "hiro-sun.vscode-emacs"
    "jbw91.theme-material-dark-soda"
    "lukehoban.Go"
    "selbh.keyboard-scroll"
    "ms-vscode.cpptools"
    "redhat.java"
    "gerane.Theme-ArtSchool"
    )

for e in "${arr[@]}"
do
   code --install-extension "$e"
done

############################
# copy user preferences (-n no clobber!)
############################

cp -n ./settings.json "$HOME/.config/Code/User/settings.json"
cp -n ./keybindings.json "$HOME/.config/Code/User/keybindings.json"

############################
# deps listing
############################
whereis clang-format
whereis java
