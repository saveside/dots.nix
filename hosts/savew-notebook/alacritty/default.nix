{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.pkgconfig.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty configuration.";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "vibrant-ink";
      description = "Alacritty theme.";
    };
  };
  config.programs.alacritty = {
    enable = config.pkgconfig.alacritty.enable;
    package = config.wrappedPkgs.alacritty;

    settings = {
      #~ Font
      # font.size = config.stylix.fonts.sizes.terminal;
      env.TERM = "xterm-256color";
      font.size = 10;
      font.normal = {
        # family = config.stylix.fonts.monospace.name;
        family = "JetBrainsMono Nerd Font";
        style = "Bold";
      };
      font.bold = {
        family = "Monaspace Neon";
        style = "ExtraBold";
      };
      font.italic = {
        family = "Monaspace Neon";
        style = "Italic";
      };
      font.bold_italic = {
        family = "Monaspace Neon";
        style = "Bold Italic";
      };
      window.opacity = 0.45;
      window.padding = {
        x = 15;
        y = 15;
      };

      general.ipc_socket = true;
      general.import = [
        inputs.alacritty-theme.packages."${pkgs.system}"."${config.pkgconfig.alacritty.theme}"
      ];
    };
  };
}
