# Docker + libvirt + virt-manager
{ config, lib, pkgs, ... }:

let
  cfg = config.cfg.virtualization;
in
{
  options.cfg.virtualization.enable = lib.mkEnableOption "Docker, libvirt, virt-manager";

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
          daemon.settings.dns = "1.1.1.1";
        };
      };
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    programs.virt-manager.enable = true;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    systemd.services.libvirtd.path = [ pkgs.nftables ];
  };
}
