{ config, pkgs, ... }:

let
  vesperTheme = {
    primary = {
      foreground = "#ffffff";
      background = "#000000";
    };

    cursor = {
      text = "#ffffff";
      cursor = "#acb1ab";
    };

    selection = {
      text = "#b9beb8";
      background = "#988049";
    };

    normal = {
      black = "#101010";
      red = "#f5a191";
      green = "#90b99f";
      yellow = "#e6b99d";
      blue = "#aca1cf";
      magenta = "#e29eca";
      cyan = "#ea83a5";
      white = "#a0a0a0";
    };

    bright = {
      black = "#7e7e7e";
      red = "#ff8080";
      green = "#99ffe4";
      yellow = "#ffc799";
      blue = "#b9aeda";
      magenta = "#ecaad6";
      cyan = "#f591b2";
      white = "#ffffff";
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
