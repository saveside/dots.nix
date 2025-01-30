{ config, ... }:

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
      "*" = {
        adaptive_sync = "off";
        subpixel = "rgb";
      };
    };
  };
}
