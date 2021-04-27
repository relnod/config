{ config, pkgs, lib, ... }:

{
  programs.alacritty.enable = true;

  home.packages = with pkgs; [
    htop
    tree
    fzf
    jq
    ripgrep
    fd
    php73
    php73Packages.composer
  ];
}
