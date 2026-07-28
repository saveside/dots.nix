# Boot configuration for notebook
{ lib, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "skew_tick=1"
      "iommu=pt"
    ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "trq";
    useXkbConfig = true;
  };
}
