{ config, lib, pkgs, ... }:

let 
  monitor1 = "DP-1";
  monitor2 = "eDP-1";
  modifier = config.wayland.windowManager.hyprland.settings."$mod";
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "${modifier}, d, exec, vesktop --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode"
      "${modifier}, l, exec, gtklock"
      "${modifier}, q, exec, zen-browser"
    ];

    device = {
      name = "607d7724ed70";
      natural_scroll = false;
      disable_while_typing = true;
      accel_profile = "flat";
      sensitivity = -1;
    };

    exec-once = [
      "${lib.getExe pkgs.swayidle} -w timeout 840 '/usr/bin/gtklock' timeout 900 '${config.wrapped.sway}/bin/swaymsg output * dpms off' resume '${config.wrapped.sway}/bin/swaymsg output * dpms on'"
      "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
      "[workspace 2 silent] zen-browser"
      "[workspace 1 silent] vesktop --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode"
    ];

    monitor = [
      "${monitor1}, 1920x1080@165, 0x0, 1"
      "${monitor2}, 1920x1200@165, 1920x0, 1"
    ];

    workspace = [
      "1, monitor:${monitor1}"
      "2, monitor:${monitor2}"
      "3, monitor:${monitor2}"
      "4, monitor:${monitor1}"
      "5, monitor:${monitor2}"
      "6, monitor:${monitor2}"
      "7, monitor:${monitor2}"
      "8, monitor:${monitor2}"
      "9, monitor:${monitor2}"
      "10, monitor:${monitor2}"
    ];
  };
}
