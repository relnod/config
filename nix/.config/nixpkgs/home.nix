{ config, pkgs, ... }:


let
  neovim-nightly-overlay = import (
    builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }
  );
  unstable = import <nixpkgs-unstable> {};
in
{
  nixpkgs.overlays = [
    neovim-nightly-overlay
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.redshift.enable = true;
  services.redshift.provider = "geoclue2";

  imports = [
    ./alacritty.nix
    ./applications.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    binutils
    parted
    p7zip
    gparted

    unstable.hub
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pablo";
  home.homeDirectory = "/home/pablo";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
