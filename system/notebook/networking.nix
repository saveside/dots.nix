# Networking configuration for notebook
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

  services.zapret = {
    enable = true;
    params = [
      "--dpi-desync=fake --dpi-desync-ttl=3"
      "--dpi-desync=fake --dpi-desync-ttl=3"
      "--dpi-desync=fake --dpi-desync-ttl=3"
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
}
