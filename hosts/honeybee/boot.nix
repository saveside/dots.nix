# Boot configuration for honeybee server
{ lib, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "trq";
  };
}
