{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.ags;
in
{
  options.moduleopts.ags = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "ags";
    };
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."ags" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "saveside";
        repo = "savew-ags";
        rev = "0df7a2a";
        sha256 = "sha256-lyZQpM1iW990Lm1Hblct+IN4HZ0O0aflwPOSw2PAzSc=";
      };
    };
  };
}
