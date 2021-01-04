#!/bin/sh

paq_nvim_path="$HOME/.local/share/nvim/site/pack/paqs/opt/paq-nvim"

if [[ ! -d $paq_nvim_path ]]; then
    echo "-- Installing paq-nvim"
    git clone https://github.com/savq/paq-nvim.git "$paq_nvim_path"
else
    echo "-- Updating paq-nvim"
    cd "$paq_nvim_path"
    git pull
fi

echo "Installing/Updating Plugins"
nvim +PaqInstall +PaqUpdate +qall

echo "-- Updating Treesitter Modules"
nvim +TSUpdate +qall

cache_path="$HOME/.cache/nvim"
if [[ ! -d "$cache_path/lua-language-server" ]]; then
    echo "-- Installing lua-language-server"
    git clone https://github.com/sumneko/lua-language-server "$cache_path/lua-language-server"
    cd "$cache_path/lua-language-server"
    git submodule update --init --recursive
    cd 3rd/luamake
    ninja -f ninja/linux.ninja
    cd ../..
    ./3rd/luamake/luamake rebuild
else
    echo "-- Updating lua-language-server"
    cd "$cache_path/lua-language-server"
    git pull
    git submodule update --init --recursive
    cd 3rd/luamake
    ninja -f ninja/linux.ninja
    cd ../..
    ./3rd/luamake/luamake rebuild
fi
