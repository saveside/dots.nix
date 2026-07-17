{ ... }:

{
  wayland.windowManager.sway.config.colors = {
    focused = {
      border = "#8ba4b0";
      background = "#181616";
      text = "#c5c9c5";
      indicator = "#8ea4a2";
      childBorder = "#8ba4b0";
    };

    focusedInactive = {
      border = "#565f89";
      background = "#181616";
      text = "#a6a69c";
      indicator = "#565f89";
      childBorder = "#565f89";
    };

    unfocused = {
      border = "#181616";
      background = "#181616";
      text = "#565f89";
      indicator = "#181616";
      childBorder = "#181616";
    };

    urgent = {
      border = "#c4746e";
      background = "#181616";
      text = "#e46876";
      indicator = "#c4746e";
      childBorder = "#c4746e";
    };
  };
}
