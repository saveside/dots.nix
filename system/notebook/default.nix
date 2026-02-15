# Notebook system configuration
{ pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./networking.nix
    ./sound.nix
    ./nvidia.nix
    ./hyprland.nix
    ./virtualization.nix
    ./scheduling.nix
    ./users.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];

  programs.zsh.enable = true;

  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
}
