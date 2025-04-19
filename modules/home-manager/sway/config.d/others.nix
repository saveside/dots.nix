{
  config,
  lib,
  pkgs,
  ...
}:

{
  wayland.windowManager.sway = {
    systemd = {
      enable = true;
      variables = [
        "DISPLAY"
        "GNOME_KEYRING_CONTROL"
        "NIXOS_OZONE_WL"
        "SSH_AUTH_SOCK"
        "SWAYSOCK"
        "WAYLAND_DISPLAY"
        "XAUTHORITY"
        "XCURSOR_SIZE"
        "XCURSOR_THEME"
        "XDG_CURRENT_DESKTOP"
        "XDG_SESSION_TYPE"
      ];
    };

    config.startup = [
      #~~~ initial
      {
        command = "systemctl --user import-environment DISPLAY GNOME_KEYRING_CONTROL NIXOS_OZONE_WL SSH_AUTH_SOCK SWAYSOCK WAYLAND_DISPLAY XAUTHORITY XCURSOR_SIZE XCURSOR_THEME XDG_CURRENT_DESKTOP XDG_SESSION_TYPE";
      }
      {
        command = "${lib.getExe pkgs.waypaper} --restore";
      }

      {
        command = "${config.wrapped.sway}/bin/swaymsg workspace 1 && zen-browser";
      }
      {
        command = "${config.wrapped.sway}/bin/swaymsg workspace 2 && vesktop --ozone-platform=wayland --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode";
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
      {
        command = "${lib.getExe pkgs.swaynotificationcenter}";
      }
    ];
  };
}
