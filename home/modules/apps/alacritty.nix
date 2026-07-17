{ config, pkgs, ... }:
let
  tokyoNight = {
    primary = {
      foreground = "#c5c9c5";
      background = "#181616";
    };
    cursor = {
      text = "#181616";
      cursor = "#c5c9c5";
    };
    selection = {
      text = "#c8c093";
      background = "#2d4f67";
    };
    normal = {
      black = "#0d0c0c";
      red = "#c4746e";
      green = "#8a9a7b";
      yellow = "#c4b28a";
      blue = "#8ba4b0";
      magenta = "#a292a3";
      cyan = "#8ea4a2";
      white = "#c8c093";
    };
    bright = {
      black = "#a6a69c";
      red = "#e46876";
      green = "#87a987";
      yellow = "#e6c384";
      blue = "#7fb4ca";
      magenta = "#938aa9";
      cyan = "#7aa89f";
      white = "#c5c9c5";
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
        opacity = 1.0;
        padding = {
          x = 15;
          y = 15;
        };
      };
      colors = tokyoNight;
    };
  };
}
