# Laptop power / wifi / ASUS bits — safe to leave off on desktops and servers
{ config, lib, pkgs, ... }:

let
  cfg = config.cfg.laptop;
in
{
  options.cfg.laptop.enable = lib.mkEnableOption "TLP, wifi power tuning, asusd";

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = {
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";
      };
    };

    networking.networkmanager.wifi.powersave = false;

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlo1", RUN+="${pkgs.iw}/bin/iw dev wlo1 set power_save off"
    '';

    boot.kernelParams = [
      "iwlwifi.power_save=0"
      "iwlmvm.power_scheme=1"
    ];

    services.asusd.enable = true;
  };
}
