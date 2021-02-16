{ config, pkgs, lib, ... }:

{
  programs.alacritty.enable = true;

  home.packages = with pkgs; [
    htop
    tree
    fzf
    jq
  ];
}
