# Networking configuration for notebook
{ ... }:

{
  services.ivpn.enable = true;
  networking.networkmanager.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  services.resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNS = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
          ];
          DNSOverTLS = "true";
          DNSSEC = "true";
          Domains = [ "~." ];
          FallbackDNS = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
          ];
        };
      };
    };
  networking.networkmanager.dns = "systemd-resolved";

  boot.blacklistedKernelModules = [ "btusdb" ];

  services.zapret = {
    enable = true;
    params = [
      "--filter-tcp=80,443"
      "--dpi-desync=fake --dpi-desync-ttl=3"
      #"--filter-udp=443"
    ];
    whitelist = [
      "discord.com"
      "gateway.discord.gg"
      "cdn.discordapp.com"
      "discordapp.net"
      "googleapis.com"
      "discord-attachments-uploads-prd.storage.googleapis.com"
      "dis.gd"
      "discord.co"
      "discord.design"
      "discord.dev"
      "discord.gg"
      "discord.gift"
      "discord.gifts"
      "discord.media"
      "discord.new"
      "discord.store"
      "discord.tools"
      "discordapp.com"
      "discordmerch.com"
      "discordpartygames.com"
      "discord-activities.com"
      "discordactivities.com"
      "discordsays.com"
      "discordstatus.com"
      "roblox.com"
      "hianime.to"
    ];
  };

  services.tailscale.enable = true;
  programs.localsend.openFirewall = true;
  networking.networkmanager.wifi.powersave = false;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 4242 ];
    allowedUDPPorts = [ 5353 ];
  };
}
