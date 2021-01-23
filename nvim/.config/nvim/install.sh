#!/bin/sh

echo "-- Installing/Updating Plugins"
nvim +PaqClean +PaqInstall +PaqUpdate +qall

echo "-- Updating Treesitter Modules"
nvim +TSUpdate +qall
