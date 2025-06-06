{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.rofi;
in
{
  options.moduleopts.rofi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Rofi";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = ".config/rofi/custom.rasi";
    };

    xdg.configFile."rofi/custom.rasi".text = ''
      * {
          font: "${config.stylix.fonts.sansSerif.name} 8";

          bg0: #000000a6;
          bg1: #7E7E7E80;
          bg2: #0860f2D6;

          fg0: #DEDEDE;
          fg1: #FFFFFF;
          fg2: #DEDEDE80;

          background-color: transparent;
          text-color: @fg0;

          margin: 0;
          padding: 0;
          spacing: 0;
      }

      window {
          transparency: "real";
          background-color: @bg0;
          location: center;
          width: 640;
          y-offset: 00;
          border-radius: 12;
      }

      inputbar {
          font: "Montserrat 20";
          padding: 12px;
          spacing: 12px;
          children: [ icon-search, entry ];
      }

      icon-search {
          expand: false;
          filename: "search";
          size: 28px;
      }

      icon-search,
      entry,
      element-icon,
      element-text {
          vertical-align: 0.5;
      }

      entry {
          font: inherit;
          placeholder: "Search";
          placeholder-color: @fg2;
      }

      message {
          border: 2px 0 0;
          border-color: @bg1;
          background-color: @bg1;
      }

      textbox {
          padding: 8px 24px;
      }

      listview {
          lines: 10;
          columns: 1;

          fixed-height: false;
          border: 1px 0 0;
          border-color: @bg1;
      }

      element {
          padding: 8px 16px;
          spacing: 16px;
          background-color: transparent;
      }

      element normal active {
          text-color: @bg2;
      }

      element selected normal,
      element selected active {
          background-color: @bg2;
          text-color: @fg1;
      }

      element-icon {
          size: 1em;
      }

      element-text {
          text-color: inherit;
      }
    '';
  };
}
