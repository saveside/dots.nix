{
  config,
  lib,
  ...
}:

let
  cfg = config.moduleopts.zathura;
in
{
  options.moduleopts.zathura = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "zathura";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";

        default-bg = "#1d2021";
        statusbar-fg = "#B0B0B0"; # 04;
        statusbar-bg = "#202020"; # 01;

        inputbar-bg = "#151515"; # 00; currently not used
        inputbar-fg = "#FFFFFF"; # 02;

        notification-error-bg = "#AC4142"; # 08;
        notification-error-fg = "#151515"; # 00;

        notification-warning-bg = "#AC4142"; # 08;
        notification-warning-fg = "#151515"; # 00;

        completion-highlight-fg = "#151515"; # 02;
        completion-highlight-bg = "#90A959"; # 0C;

        completion-bg = "#303030"; # 02;
        completion-fg = "#E0E0E0"; # 0C;

        notification-bg = "#90A959"; # 0B;
        notification-fg = "#151515"; # 00;

        recolor = true;
        recolor-keephue = true;
        recolor-reverse-video = true;
        recolor-lightcolor = "#1d2021";
        recolor-darkcolor = "#d4be98";

        scroll-page-aware = true;
        smooth-scroll = true;
        scroll-full-overlap = "0.01";
        scroll-step = 100;

        # Font
        font = "${config.stylix.fonts.sansSerif.name} ${
          builtins.toString (config.stylix.fonts.sizes.applications + 3)
        }";
      };
      mappings = {
        f = "toggle_fullscreen";
        "[fullscreen] f" = "toggle_fullscreen";
      };
    };
  };
}
