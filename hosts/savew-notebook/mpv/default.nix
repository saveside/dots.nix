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
    package = config.lib.nixGL.wrap pkgs.mpv;
  };
  config.xdg.configFile."mpv" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "Tsubajashi";
      repo = "mpv-settings";
      rev = "f859a9a";
      sha256 = "";
    };
  };
 }

