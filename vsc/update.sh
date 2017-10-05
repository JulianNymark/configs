#!/usr/bin/env bash
set -euo pipefail

############################
# update with current user preferences
############################

cp "$HOME/.config/Code/User/settings.json" ./settings.json
cp "$HOME/.config/Code/User/keybindings.json" ./keybindings.json
