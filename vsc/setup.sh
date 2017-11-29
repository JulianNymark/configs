#!/usr/bin/env bash
set -euo pipefail

# this script will:
# 1. try to install vsc extensions
# 2. copy keybindings.json & settings.json into your user preferences

############################
# try to install extentions
############################

declare -a arr=(
	"dbaeumer.vscode-eslint"
	"EditorConfig.editorconfig"
	"eg2.tslint"
	"foxundermoon.shell-format"
	"geddski.macros"
	"gerane.Theme-ArtSchool"
	"hiro-sun.vscode-emacs"
	"jbw91.theme-material-dark-soda"
	"JPTarquino.postgresql"
	"lukehoban.Go"
	"ms-vscode.cpptools"
	"PeterJausovec.vscode-docker"
	"redhat.java"
	"selbh.keyboard-scroll"
)

for e in "${arr[@]}"; do
	code --install-extension "$e"
done

############################
# copy user preferences (-n no clobber!)
############################

user_settings_directory="$HOME/.config/Code/User"

if [ "$(uname)" == "Darwin" ]; then
	user_settings_directory="$HOME/Library/Application\ Support/Code/User"
fi

cp -n ./settings.json "$user_settings_directory/settings.json"
cp -n ./keybindings.json "$user_settings_directory/keybindings.json"

############################
# deps listing
############################
whereis clang-format
whereis java
