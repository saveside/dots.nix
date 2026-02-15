# Foot terminal configuration
{ ... }:

{
  programs.foot = {
    enable = true;
    server.enable = false;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:style=Bold:size=10";
        font-bold = "Monaspace Neon:style=ExtraBold:size=10";
        font-italic = "Monaspace Neon:style=Italic:size=10";
        font-bold-italic = "Monaspace Neon:style=Bold Italic:size=10";
        pad = "15x15";
        dpi-aware = "yes";
	include = "~/.config/foot/colors.ini";
      };

      cursor = {
        style = "block";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      key-bindings = {
        font-increase = "Control+Shift+plus";
        font-decrease = "Control+Shift+underscore";
        font-reset = "Control+0";
      };
    };
  };
}
