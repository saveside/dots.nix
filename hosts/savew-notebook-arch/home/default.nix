{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

{
  ########################################
  #
  ## Home Manager Required Variables
  #
  ########################################
  home.username = "savew";
  home.homeDirectory = "/home/savew";
  nixGL.packages = inputs.nixgl.packages;
  wrapped.enable = true;

  ########################################
  #
  ## Packages
  #
  ########################################
  #~ home.packages ~#
  home.packages = [
    config.wrapped.alacritty
    config.wrapped.flameshot
    config.wrapped.imagemagick
    config.wrapped.nwg-displays
    config.wrapped.qt5ct
    config.wrapped.qt6ct
    config.wrapped.vscode
  ];

  ########################################
  #
  ## Module Configurations
  #
  ########################################
  #~ custom modules ~#
  moduleopts = {
    flatpak.enable = false;
    fontconfig.enable = true;
    gtk.enable = true;
    kde.enable = true;
    sway.enable = false;
    qt.enable = true;
    rnnoise-denoising.enable = true;
  };

  ########################################
  #
  ## Custom Modules
  #
  ########################################
  imports = lib.map (p: ./. + "/${p}") (
    builtins.filter (p: !(p == "default.nix" || lib.hasSuffix ".txt" p)) (
      lib.attrNames (builtins.readDir ./.)
    )
  );
}
