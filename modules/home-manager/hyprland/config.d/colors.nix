{ config, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$background" = "rgb(${config.lib.stylix.colors.base00})";
    "$foreground" = "rgb(${config.lib.stylix.colors.base05})";
    "$active" = "rgb(${config.lib.stylix.colors.base0D})";
    "$inactive" = "rgb(${config.lib.stylix.colors.base03})";
    "$inactive2" = "rgb(${config.lib.stylix.colors.base03})"; # Assuming inactive2 maps to base03 as well
    "$urgent" = "rgb(${config.lib.stylix.colors.base0C})";
    "$primary" = "rgb(${config.lib.stylix.colors.base05})";
    "$secondary" = "rgb(${config.lib.stylix.colors.base0D})";
  };
}
