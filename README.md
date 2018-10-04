# Personal Dotfiles

## Configurations

* Terminal: [allacritty](https://github.com/jwilm/alacritty) + tmux
* Editor: [nvim](https://github.com/neovim/neovim), vim
* Shell: bash, zsh
* Misc: git, ctags, xorg, i3wm

Additional programs: rg, fzf

## Management
Dotfiles are managed with [dotm](https://github.com/relnod/dotm). Run `dotm help` for a complete list of commands.

### Install
```
dotm install github.com/relnod/dotfiles
```

### Update
```
dotm update --fromRemote
```

### Uninstall
```
./dotm.sh unlink
```
