{ config, pkgs, lib, ... }:

let
  unstable = import <nixpkgs-unstable> {};
in
{
  programs.neovim.enable = true;
  programs.neovim.package = pkgs.neovim-nightly;

  programs.neovim.extraPackages = with pkgs; [
    # For Treesitter
    gcc

    # For LSP
    unstable.gopls
    rnix-lsp
    nodePackages.prettier
    nodePackages.typescript-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.yaml-language-server
    nodePackages.vscode-json-languageserver-bin
    nodePackages.vscode-css-languageserver-bin
    nodePackages.bash-language-server
    unstable.sumneko-lua-language-server
    clang-tools # for ccls

    # For Telescope
    ripgrep
    fd
    bat
    fzy
  ];
}
