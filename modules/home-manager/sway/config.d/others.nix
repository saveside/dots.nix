{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  wayland.windowManager.sway = {
    systemd = {
      enable = true;
      variables = [
        "DISPLAY"
        "GNOME_KEYRING_CONTROL"
        "LD_LIBRARY_PATH"
        "NIXOS_OZONE_WL"
        "PATH"
        "SSH_AUTH_SOCK"
        "SWAYSOCK"
        "WAYLAND_DISPLAY"
        "XAUTHORITY"
        "XCURSOR_SIZE"
        "XCURSOR_THEME"
        "XDG_CURRENT_DESKTOP"
        "XDG_DATA_DIRS"
        "XDG_SESSION_TYPE"
      ];
      xdgAutostart = true;
    };

    config.startup = [
      #~~~ initial
      {
        command = "systemctl --user import-environment DISPLAY GNOME_KEYRING_CONTROL LD_LIBRARY_PATH NIXOS_OZONE_WL PATH SSH_AUTH_SOCK SWAYSOCK WAYLAND_DISPLAY XAUTHORITY XCURSOR_SIZE XCURSOR_THEME XDG_CURRENT_DESKTOP XDG_DATA_DIRS XDG_SESSION_TYPE";
      }
      {
        command = "${lib.getExe pkgs.waypaper} --restore";
      }
      {
        command = "${lib.getExe pkgs.pcmanfm-qt} -d";
      }
      {
        command = "${lib.getExe config.wrapped.alacritty} -t daemonmodealacritty";
      }
      {
        command = "${lib.getExe pkgs.nextcloud-client}";
      }
      {
        command = "${config.wrapped.sway}/bin/swayidle -w timeout 240 \"${lib.getExe pkgs.gtklock}\" timeout 300 '${config.wrapped.sway}/bin/swaymsg \"output * dpms off\"' resume '${config.wrapped.sway}/bin/swaymsg \"output * dpms on\"'";
      }
      {
        command = "${lib.getExe pkgs.networkmanagerapplet}";
      }
      {
        command = "${lib.getExe pkgs.autotiling-rs}";
      }
      {
        command = "${lib.getExe config.wrapped.flameshot}";
      }
    ];
  };
}
