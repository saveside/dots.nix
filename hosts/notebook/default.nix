{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./users.nix
  ];

  # ─── feature toggles ────────────────────────────────────────────
  cfg = {
    sway.enable = true;
    hyprland.enable = true;
    nvidia.enable = true;
    virtualization.enable = true;
    gaming.enable = true;
    laptop.enable = true;
    sound.enable = true;
    scheduling.enable = true;
  };

  # ─── host identity ──────────────────────────────────────────────
  networking.hostName = "savew-notebook";
  networking.hosts."127.0.0.1" = [ "yagis.me" ];

  # NVIDIA Optimus PCI bus IDs — host hardware, not a feature flag
  hardware.nvidia.prime = {
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };

  # ─── notebook-specific system bits ──────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
    swapDevices = 1;
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.upower.enable = true;
  programs.kdeconnect.enable = true;

  system.stateVersion = "26.05";
}
