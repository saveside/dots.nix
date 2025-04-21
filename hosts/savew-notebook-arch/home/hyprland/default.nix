{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    device = {
      name = "607d7724ed70";
      natural_scroll = false;
      disable_while_typing = true;
      accel_profile = "flat";
      sensitivity = -1;
    };

    "$scr1" = "DP-1";
    "$scr2" = "eDP-2";

    monitor = [
      "$scr1, 1920x1080@165, 0x0, 1"
      "$scr2, 1920x1200@165, 1920x0, 1"
    ];

    exec-once = [
      "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    ];
  };
}
