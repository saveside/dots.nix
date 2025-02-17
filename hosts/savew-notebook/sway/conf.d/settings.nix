{ config, ... }:

let
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  wayland.windowManager.sway = {
    config = {
      bars = [
        {
          command = "waybar";
          position = "top";
          workspaceButtons = true;
        }
      ];
      floating.modifier = "${modifier}";
      gaps = {
        inner = 3;
        outer = 0;
        smartBorders = "on";
        smartGaps = false;
      };
      workspaceLayout = "default";
      seat = {
        "*" = {
          xcursor_theme = "Bibata-Modern-Classic 16";
        };
      };
    };
    extraConfig = ''
      #~~~ window
      default_border                                   pixel 2
      default_floating_border                          none
      hide_edge_borders --i3                           none

      #~~~ swayfx rules
      blur enable
      blur_radius 10
      blur_passes 3
      blur_noise 0.02
      blur_saturation 1.2
      blur_contrast 1.1
      shadows disable
      corner_radius 12
      layer_effects "rofi" blur enable
      #layer_effects "waybar" blur enable
      layer_effects "zen-beta" blur enable
      layer_effects "swaync" blur enable

      #~~~ window rules
      for_window [title="^daemonmodealacritty$"] move container to scratchpad
      for_window [app_id="flameshot"] border pixel 0, floating enable, fullscreen disable, move absolute position 0 0
      for_window [shell="xwayland"] title_format "[X] %title", border pixel 8

      #~~~ workspaces
      workspace 1 output $scr1
      workspace 2 output $scr1
      workspace 3 output $scr1
      workspace 4 output $scr1
      workspace 5 output $scr1
      workspace 6 output $scr2
      workspace 7 output $scr2
      workspace 8 output $scr2
      workspace 9 output $scr2

      #~~~ other
      include $HOME/.config/sway/config.d/*
    '';
  };
}
