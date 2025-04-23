{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.moduleopts.alacritty;
in
{
  options.moduleopts.alacritty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "alacritty";
    };
    theme = lib.mkOption {
      type = lib.types.str;
      default = "vibrant-ink";
      description = "theme";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      package = config.wrapped.alacritty;

      settings = {
        font.size = config.stylix.fonts.sizes.terminal;
        font.normal = {
          family = config.stylix.fonts.monospace.name;
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
        colors.primary = {
          background = "#000000";
        };
        general.import = [
          inputs.alacritty-theme.packages."${pkgs.system}"."${cfg.theme}"
        ];
      };
    };
  };
}
