{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    group = {
      groupbar = {
        enabled = true;
        font_family = "Source Code Pro Semi-Bold";
        font_size = 8;
      };
    };

    decoration = {
      rounding = 0;
      blur = {
        enabled = true;
        size = 10;
        noise = 0.02;
        passes = 2;
        contrast = 1.1;
        vibrancy = 0.1696;
        xray = true;
      };
      shadow.enabled = false;
    };

    general = {
      allow_tearing = true;
      border_size = 2;
      "col.active_border" = "#ffffff";
      "col.inactive_border" = "#000000";
      gaps_in = 5;
      gaps_out = 5;
    };

    animations.enabled = false;

    misc = {
      vrr = 2;
      vfr = true;
    };
  };
}
