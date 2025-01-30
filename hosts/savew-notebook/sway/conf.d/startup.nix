{ pkgs, ... }:

{
  wayland.windowManager.sway = {
    config.startup = [
      #~~~ gtk configuration
      {
        command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XAUTHORITY SSH_AUTH_SOCK GNOME_KEYRING_CONTROL";
      }
      {
        command = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XAUTHORITY SSH_AUTH_SOCK GNOME_KEYRING_CONTROL";
      }
      {
        command = "dbus-update-activation-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XAUTHORITY SSH_AUTH_SOCK GNOME_KEYRING_CONTROL";
      }

      {
        command = "waypaper --restore";
      }

      {
        command = "swaymsg workspace 1 && zen-browser";
      }
      {
        command = "swaymsg workspace 2 && vesktop --ozone-platform=wayland --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode";
      }

      {
        command = "--no-startup-id /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
      }
      {
        command = "pcmanfm-qt -d";
      }
      {
        command = "alacritty -t daemonmodealacritty";
      }
      {
        command = "nextcloud";
      }
      {
        command = "${pkgs.sway}/bin/swayidle -w timeout 240 \"gtklock\" timeout 300 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"'";
      }
      {
        command = "ags # Widgets";
      }
      {
        command = "nm-applet";
      }
      {
        command = "/usr/bin/kdeconnectd";
      }
      {
        command = "autotiling-rs";
      }
      {
        command = "flameshot";
      }
      {
        command = "1password";
      }
    ];
  };
}
