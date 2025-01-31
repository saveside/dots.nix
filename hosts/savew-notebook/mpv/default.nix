{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.pkgconfig.mpv = {
    enable = lib.mkEnableOption "Enable mpv configuration.";
  };
  config.programs.mpv = {
    enable = config.pkgconfig.mpv.enable;
    package = config.wrappedPkgs.mpv;
  };
  config.xdg.configFile."mpv" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "Tsubajashi";
      repo = "mpv-settings";
      rev = "f859a9a";
      sha256 = "sha256-Wie8FLDvfHCHdF4aa1EW9Bd71kuViFfhUek0MY8kHCw=";
    };
  };
}
