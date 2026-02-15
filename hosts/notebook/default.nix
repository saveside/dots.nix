{ ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
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

  # Caddy reverse proxy
  services.caddy = {
    enable = true;
    virtualHosts = {
      "sync.yagis.me" = {
        extraConfig = ''
          reverse_proxy localhost:8384
        '';
      };
    };
  };

  system.stateVersion = "25.11";
}
