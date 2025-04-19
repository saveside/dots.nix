{ config, ... }:

let
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  wayland.windowManager.sway.config = {
    output = {
      "DP-1" = {
        mode = "1920x1080@165Hz";
        position = "1920,0";
      };
      "eDP-1" = {
        mode = "1920x1200@165Hz";
        position = "0,0";
      };
    };
    keybindings = {
      "${modifier}+l" = "exec /usr/bin/gtklock";
    };
    startup = [
      {
        command = "--no-startup-id /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
      }
      {
        command = "1password";
      }
    ];
  };
}
