{ config, lib, ... }:

let
  cfg = config.moduleopts.sway;
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  wayland.windowManager.sway.config = lib.mkIf cfg.enable {
    keybindings = {
      "${modifier}+g" = "exec /opt/1Password/1password --quick-access";
      "${modifier}+l" = "exec /usr/bin/gtklock";
    };
    output = {
      "DP-1" = {
        mode = "1920x1080@165";
        position = "1920,0";
      };
      "eDP-1" = {
        mode = "1920x1200@165";
        position = "0,0";
      };
    };
    startup = [
      {
        command = "${config.wrapped.sway}/bin/swaymsg workspace 1 && zen-browser";
      }
      {
        command = "${config.wrapped.sway}/bin/swaymsg workspace 2 && vesktop --ozone-platform=wayland --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode";
      }
      {
        command = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
      }
      {
        command = "/opt/1Password/1password --silent --password-store=gnome";
      }
    ];
  };
}
