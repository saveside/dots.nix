{ ... }:

{
  wayland.windowManager.sway.config = {
    output = {
      "*" = {
        adaptive_sync = "off";
        subpixel = "rgb";
      };
    };
  };
}
