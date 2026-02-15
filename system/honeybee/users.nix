# User configuration for honeybee server
{ pkgs, ... }:

{
  users.users.savew = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
