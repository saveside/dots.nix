{ ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
  ];

  networking.hostName = "savew-honeybee";

  # Host-specific NixOS configuration for honeybee server
  # Configure your server-specific services here

  system.stateVersion = "25.11";
}
