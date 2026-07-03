{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; # Ensure you are using the Wayland fork
    theme = "${pkgs.rofi}/share/rofi/themes/Monokai.rasi";
    extraConfig = {
      show-icons = true;
      modes = "window,drun,run,ssh";
      font = "JetBrainsMono NF 18";
      drun-display-format = "{name}";
    };
  };
}
