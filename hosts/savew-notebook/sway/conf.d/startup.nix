{ config, pkgs, ... }:

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
        command = "${pkgs.waypaper}/bin/waypaper --restore";
      }

      {
        command = "${config.wrappedPkgs.sway}/bin/swaymsg workspace 1 && zen-browser";
      }
      {
        command = "${config.wrappedPkgs.sway}/bin/swaymsg workspace 2 && vesktop --ozone-platform=wayland --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode";
      }

      {
        command = "--no-startup-id /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
      }
      {
        command = "${pkgs.pcmanfm-qt}/bin/pcmanfm-qt -d";
      }
      {
        command = "${config.wrappedPkgs.alacritty}/bin/alacritty -t daemonmodealacritty";
      }
      {
        command = "${pkgs.nextcloud-client}/bin/nextcloud";
      }
      {
        command = "${config.wrappedPkgs.sway}/bin/swayidle -w timeout 240 \"${pkgs.gtklock}/bin/gtklock\" timeout 300 '${config.wrappedPkgs.sway}/bin/swaymsg \"output * dpms off\"' resume '${config.wrappedPkgs.sway}/bin/swaymsg \"output * dpms on\"'";
      }
      # {
      #   command = "${pkgs.ags}/bin/ags";
      # }
      {
        command = "nm-applet";
      }
      {
        command = "${pkgs.autotiling-rs}/bin/autotiling-rs";
      }
      {
        command = "${config.wrappedPkgs.flameshot}/bin/flameshot";
      }
      {
        command = "1password";
      }
      {
        command = "${pkgs.swaynotificationcenter}/bin/swaync";
      }
    ];
  };
}
