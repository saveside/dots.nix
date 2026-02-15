# Networking configuration for honeybee server
{ ... }:

{
  networking.networkmanager.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  services.resolved = {
    enable = true;
    dnsovertls = "true";
    dnssec = "true";
    domains = [ "~." ];
    llmnr = "true";
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
    ];
  };

  services.tailscale.enable = true;
}
