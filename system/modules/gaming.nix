# Steam + gaming bits (system-level enable only; user packages stay in home profile)
{ config, lib, ... }:

let
  cfg = config.cfg.gaming;
in
{
  options.cfg.gaming.enable = lib.mkEnableOption "Steam + Remote Play firewall";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
