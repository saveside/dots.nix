# Hyprland (home-manager only; no system-level bits in this repo)
{ config, lib, ... }:

let
  cfg = config.cfg.hyprland;
in
{
  options.cfg.hyprland.enable = lib.mkEnableOption "Hyprland (home-manager)";

  config = lib.mkIf cfg.enable {
    home-manager.users.savew.imports = [ ../../home/modules/desktop/hyprland ];
  };
}
