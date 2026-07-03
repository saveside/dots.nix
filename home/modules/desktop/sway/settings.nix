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
}
