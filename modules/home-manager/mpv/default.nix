{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.mpv;
in
{
  options.moduleopts.mpv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "MPV";
    };
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."mpv" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "Tsubajashi";
        repo = "mpv-settings";
        rev = "f859a9a";
        sha256 = "sha256-Wie8FLDvfHCHdF4aa1EW9Bd71kuViFfhUek0MY8kHCw=";
      };
    };
  };
}
