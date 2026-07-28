{ config, pkgs, ... }:
let
  blueNord = {
    primary = {
      foreground = "#eceff4";
      background = "#000000";
    };
    cursor = {
      text = "#000000";
      cursor = "#eceff4";
    };
    selection = {
      text = "#eceff4";
      background = "#5e81ac";
    };
    normal = {
      black = "#1a2433";
      red = "#bf616a";
      green = "#a3be8c";
      yellow = "#ebcb8b";
      blue = "#5e81ac";
      magenta = "#81a1c1";
      cyan = "#88c0d0";
      white = "#d8dee9";
    };
    bright = {
      black = "#4c566a";
      red = "#bf616a";
      green = "#a3be8c";
      yellow = "#ebcb8b";
      blue = "#5e81ac";
      magenta = "#81a1c1";
      cyan = "#8fbcbb";
      white = "#eceff4";
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
      colors = blueNord;
    };
  };
}
