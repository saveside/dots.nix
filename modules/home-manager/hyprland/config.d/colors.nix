{ config, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$background" = "rgb(${lib.strings.removePrefix "#" config.colors.backgroundColor})";
    "$foreground" = "rgb(${lib.strings.removePrefix "#" config.colors.textColor})";
    "$active" = "rgb(${lib.strings.removePrefix "#" config.colors.activeColor})";
    "$inactive" = "rgb(${lib.strings.removePrefix "#" config.colors.inactiveColor})";
    "$inactive2" = "rgb(${lib.strings.removePrefix "#" config.colors.inactiveColor2})";
    "$urgent" = "rgb(${lib.strings.removePrefix "#" config.colors.urgentColor})";
    "$primary" = "rgb(${config.lib.stylix.colors.base05})";
    "$secondary" = "rgb(${config.lib.stylix.colors.base0D})";
  };
}
