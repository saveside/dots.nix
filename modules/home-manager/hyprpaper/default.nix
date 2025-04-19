{ config, lib, ... }:

let
  cfg = config.moduleopts.hyprpaper;
in
{
  options.moduleopts.hyprpaper = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "hyprpaper";
    };
  };
  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      importantPrefixes = [ "$" ];
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;
      };
    };
  };
}
