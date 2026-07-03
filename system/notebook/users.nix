# User configuration for notebook
{ pkgs, ... }:

{
  users.users.savew = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "libvirtd"
      "docker"
      "render"
    ];
  };
}
