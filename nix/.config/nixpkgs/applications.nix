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

  services.keybase.enable = true;
  services.kbfs.enable = true;
  home.packages = with pkgs; [
    # Utils
    gnome3.nautilus # File Explorer
    gnome3.eog # Image Viewer
    gnome3.evince # Pdf Viewer
    vlc # Video Viewer

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
    keybase
    keybase-gui
    mumble

    # Browser
    firefox
    chromium
    unstable.torbrowser

    virt-manager

    calibre
  ];
}
