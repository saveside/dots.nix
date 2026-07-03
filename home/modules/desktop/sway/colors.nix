{ ... }:

{
  wayland.windowManager.sway.config.colors = {
    focused = {
      border = "#52525b";
      background = "#27272a";
      text = "#f4f4f5";
      indicator = "#a1a1aa";
      childBorder = "#52525b";
    };

    focusedInactive = {
      border = "#27272a";
      background = "#18181b";
      text = "#a1a1aa";
      indicator = "#27272a";
      childBorder = "#27272a";
    };

    unfocused = {
      border = "#18181b";
      background = "#18181b";
      text = "#71717a";
      indicator = "#18181b";
      childBorder = "#18181b";
    };

    urgent = {
      border = "#ef4444";
      background = "#7f1d1d";
      text = "#fca5a5";
      indicator = "#ef4444";
      childBorder = "#ef4444";
    };
  };
}
