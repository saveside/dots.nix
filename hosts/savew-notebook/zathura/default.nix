{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.pkgconfig.zathura = {
    enable = lib.mkEnableOption "Enable zathura configuration.";
  };
  config.programs.zathura = {
    enable = config.pkgconfig.zathura.enable;
    package = pkgs.zathura;
    options = {
      selection-clipboard = "clipboard";

      # color config

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

      # scrolling

      scroll-page-aware = true;
      smooth-scroll = true;
      scroll-full-overlap = "0.01";
      scroll-step = 100;

      # Font
      font = "SF Pro Display 15";
    };
    mappings = {
      f = "toggle_fullscreen";
      "[fullscreen] f" = "toggle_fullscreen";

    };
  };

}
