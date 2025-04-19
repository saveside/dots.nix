{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    input = {
      #~~~ keyboard configuration
      kb_layout = "tr";
      numlock_by_default = true;
      kb_options = "grp:win_space_toggle";

      #~~~ touchpad configuration (for Laptops)
      touchpad = {
        disable_while_typing = true;
        tap-to-click = true;
        natural_scroll = false;
        middle_button_emulation = true;
      };
    };
  };
}
