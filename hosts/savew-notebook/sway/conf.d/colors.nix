{ config, ... }:

{
  wayland.windowManager.sway.config = {
    fonts = {
      names = [
        #config.stylix.fonts.sansSerif.name
        "Source Code Pro Semi-Bold"
        "pango"
      ];
      size = 6.0;
    };
    colors = {
      background = "#e0e0e0";

      focused = {
        background = "#e0e0e0";
        border = "#e0e0e0";
        text = "#333333";
        indicator = "#e0e0e0";
        childBorder = "#e0e0e0";
      };

      focusedInactive = {
        background = "#282828";
        border = "#282828";
        text = "#f4f4f8";
        indicator = "#282828";
        childBorder = "#282828";
      };

      unfocused = {
        background = "#282828";
        border = "#282828";
        text = "#666666";
        indicator = "#282828";
        childBorder = "#282828";
      };

      urgent = {
        background = "#fd472f";
        border = "#fd472f";
        text = "#282828";
        indicator = "#e0e0e0";
        childBorder = "#fd472f";
      };
    };
  };
}
