{ config, pkgs, lib, ... }:

let
  unstable = import <nixpkgs-unstable> {};
in
{
  programs.alacritty.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "spotify"
      "zoom"
    ];

  home.packages = with pkgs; [
    # Utils
    gnome3.nautilus # File Explorer
    gnome3.eog # Image Viewer
    gnome3.evince # Pdf Viewer

    # Passwort Manager
    keepassxc

    # Image Creation
    gimp
    inkscape

    # Office
    libreoffice

    # Music
    spotify
    strawberry

    # E-Mail
    thunderbird

    # Messenger
    tdesktop
    unstable.signal-desktop
    mumble

    # Browser
    firefox
    chromium
    unstable.torbrowser

    virt-manager
  ];
}
