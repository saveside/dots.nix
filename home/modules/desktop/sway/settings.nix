{ config, pkgs, ... }:

{
  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
    OBSIDIAN_USE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "kvantum";
  };

  wayland.windowManager.sway.config = {
    terminal = "alacritty";
    modifier = "Mod4";
    bars = [
      { command = "waybar"; }
    ];
    window.border = 2;
    floating.border = 0;
    workspaceLayout = "default";
    window.hideEdgeBorders = "none";
    window.titlebar = false;
    gaps = {
      inner = 1;
      outer = 1;
      smartBorders = "off";
      smartGaps = false;
    };
    input = {
      "type:keyboard" = {
        xkb_layout = "tr";
      };
    };
  };

  # swayfx effects
  wayland.windowManager.sway.extraConfig = ''
    blur enable
    blur_radius 10
    blur_passes 3
    blur_noise 0.02
    blur_saturation 1.2
    blur_contrast 1.1
    shadows disable
    corner_radius 12
    layer_effects "vicinae" blur enable
    layer_effects "waybar" blur enable
    layer_effects "zen-beta" blur enable
    layer_effects "swaync" blur enable
  '';
}
