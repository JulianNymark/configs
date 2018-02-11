#!/usr/bin/env bash
set -euo pipefail

# this script will:
# 1. try to install vsc extensions
# 2. copy keybindings.json & settings.json into your user preferences

# mac or linux
USER_SETTINGS_DIRECTORY="$HOME/.config/Code/User"
if [ "$(uname)" == "Darwin" ]; then
	USER_SETTINGS_DIRECTORY="$HOME/Library/Application Support/Code/User"
fi

############################
# install extensions
############################
while read extension; do
	code --install-extension $extension
done <./list_extensions

############################
# copy user preferences (-n no clobber!)
############################

cp -n ./settings.json "$USER_SETTINGS_DIRECTORY/settings.json"
cp -n ./keybindings.json "$USER_SETTINGS_DIRECTORY/keybindings.json"

############################
# deps listing
############################
whereis clang-format
whereis java
