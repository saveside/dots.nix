{ pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      "foot --server"
      "kdeconnectd"
      "hyprpm reload -n"
      "systemctl --user start vicinae.service"
      "waybar"
      "swayosd-server"
      "flameshot"
      "nm-applet"
    ];

    exec = [
      "waypaper --restore"
    ];
  };
}
