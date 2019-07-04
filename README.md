# Personal Dotfiles

## Configurations

* Window Manager:  [i3](https://github.com/i3/i3)
* Terminal: [allacritty](https://github.com/jwilm/alacritty) + [tmux](https://github.com/tmux/tmux) + tmuxinator
* Editor: [nvim](https://github.com/neovim/neovim), vim
* Shell: bash
* Misc: git, ctags, xorg

Additional programs: rg, fzf

## Management

Dotfiles are managed with [dotm](https://github.com/relnod/dotm).
Run `dotm help` for a complete list of commands.

### Install

```shell
dotm install github.com/relnod/dotfiles --profile="relnod"

# Enable hooks
dotm config profile.relnod.hooks_enabled true
```

Next set the `GitUser` and `GitEmail` variables in the profile configuration.

```shell
dotm config profile.relnod.vars.GitUser "user"
dotm config profile.relnod.vars.GitEmail "email"

# Update the profile again to reflect changes from templates.
dotm update relnod
```

### Update

```shell
dotm update relnod --fromRemote
```

### Uninstall

```shell
dotm uninstall relnod
```
