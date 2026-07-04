{ config, pkgs, ... }:
let
  vesperTheme = {
    primary = {
      foreground = "#c0d0e0";
      background = "#000000";
    };
    cursor = {
      text = "#000000";
      cursor = "#8ab4f8";
    };
    selection = {
      text = "#c0d0e0";
      background = "#2c4f7c";
    };
    normal = {
      black = "#0d1117";
      red = "#e06c75";
      green = "#7dc4a0";
      yellow = "#e5c07b";
      blue = "#5f9fe0";
      magenta = "#8aa1e6";
      cyan = "#61afef";
      white = "#a0b0c0";
    };
    bright = {
      black = "#5c6773";
      red = "#f28b8b";
      green = "#98d8b0";
      yellow = "#f0d090";
      blue = "#8ab4f8";
      magenta = "#a9b8f0";
      cyan = "#87d0ff";
      white = "#e0ecff";
    };
  };
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      general = {
        ipc_socket = true;
      };
      env = {
        TERM = "xterm-256color";
      };
      font = {
        size = 10;

        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };

        bold = {
          family = "Monaspace Neon";
          style = "ExtraBold";
        };

        bold_italic = {
          family = "Monaspace Neon";
          style = "Bold Italic";
        };

        italic = {
          family = "Monaspace Neon";
          style = "Italic";
        };
      };
      keyboard.bindings = [
        {
          action = "IncreaseFontSize";
          key = "Plus";
          mods = "Control|Shift";
        }
        {
          action = "DecreaseFontSize";
          key = "Minus";
          mods = "Control|Shift";
        }
      ];
      window = {
        opacity = 0.85;
        padding = {
          x = 15;
          y = 15;
        };
      };
      colors = vesperTheme;
    };
  };
}
