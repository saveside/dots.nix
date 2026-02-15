# Notebook home configuration
{ inputs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ../base.nix
    ../desktop/hyprland
    ../editors.nix
    ../opencode.nix
    ../media.nix
    ../browsers.nix
    ../tools.nix
    ../matugen.nix
    ./waybar.nix
    ./foot.nix
    ./swaync.nix
    ./vicinae.nix
    ./packages.nix
  ];

  programs.home-manager.enable = true;

  xdg.mime.enable = true;

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
