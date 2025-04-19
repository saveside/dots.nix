{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$ws1" = "1";
    "$ws2" = "2";
    "$ws3" = "3";
    "$ws4" = "4";
    "$ws5" = "5";
    "$ws6" = "6";
    "$ws7" = "7";
    "$ws8" = "8";
    "$ws9" = "9";
    "$ws10" = "10";

    workspace = [
      "1, monitor:$scr1"
      "2, monitor:$scr2"
      "3, monitor:$scr2"
      "4, monitor:$scr1"
      "5, monitor:$scr2"
      "6, monitor:$scr2"
      "7, monitor:$scr2"
      "8, monitor:$scr2"
      "9, monitor:$scr2"
      "10, monitor:$scr2"
    ];
  };
}
