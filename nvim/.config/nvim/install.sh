#!/bin/sh

echo "Installing/Updating Plugins"
nvim +PaqInstall +PaqUpdate +qall

echo "-- Updating Treesitter Modules"
nvim +TSUpdate +qall
