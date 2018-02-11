#!/usr/bin/env bash
set -euo pipefail

# mac or linux
USER_SETTINGS_DIRECTORY="$HOME/.config/Code/User"
if [ "$(uname)" == "Darwin" ]; then
	USER_SETTINGS_DIRECTORY="$HOME/Library/Application Support/Code/User"
fi

############################
# update with current user preferences
############################
code --list-extensions >list_extensions

cp "$USER_SETTINGS_DIRECTORY/settings.json" ./settings.json
cp "$USER_SETTINGS_DIRECTORY/keybindings.json" ./keybindings.json
