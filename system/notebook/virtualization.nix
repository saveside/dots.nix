# Virtualization configuration for notebook
{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = "1.1.1.1";
      };
    };
  };

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  systemd.services.libvirtd.path = [ pkgs.nftables ];
}
