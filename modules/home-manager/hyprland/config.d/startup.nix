{ lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swayidle -w timeout 840 'gtklock' timeout 900 'swaymsg 'output * dpms off'' resume 'swaymsg 'output * dpms on'' &"

      "kdeconnectd &"
      "${lib.getExe pkgs.autotiling-rs} &"

      "waybar &"
      "swaync &"
      "ags &"

      "alacritty --daemon &"
      "pcmanfm-qt -d &"
      "nextcloud &"
      "flameshot &"
      "nm-applet &"
    ];
  };
}
