# Boot configuration for notebook
{ lib, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    kernelParams = [
      "zswap.enabled=1"
      "zswap.max_pool_percent=6"
      "zswap.compressor=zstd"
      "skew_tick=1"
      "intel_iommu=on"
      "iommu=pt"
    ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "trq";
    useXkbConfig = true;
  };
}
