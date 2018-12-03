# Personal Dotfiles

## Configurations

* Window Manager:  [i3](https://github.com/i3/i3)
* Terminal: [allacritty](https://github.com/jwilm/alacritty) + [tmux](https://github.com/tmux/tmux) + tmuxinator
* Editor: [nvim](https://github.com/neovim/neovim), vim
* Shell: bash
* Misc: git, ctags, xorg

Additional programs: rg, fzf

## Management
Dotfiles are managed with [dotm](https://github.com/relnod/dotm). Run `dotm help` for a complete list of commands.

### Install
```
dotm install github.com/relnod/dotfiles --profile="relnod"
```

### Update
```
dotm update relnod --fromRemote
```

### Uninstall
```
dotm uninstall relnod
```
