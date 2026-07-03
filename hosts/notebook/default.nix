{ ... }:

{
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "savew-notebook";

  # NVIDIA hybrid graphics
  hardware.nvidia = {
    enable = true;
    prime = {
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  # Local hosts
  networking.hosts = {
    "127.0.0.1" = [ "yagis.me" ];
  };

  system.stateVersion = "26.05";
}
