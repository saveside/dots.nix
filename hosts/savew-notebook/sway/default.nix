{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.pkgconfig.sway = {
    enable = lib.mkEnableOption "Enable sway window manager configuration.";
  };

  config.wayland.windowManager.sway = {
    enable = config.pkgconfig.sway.enable;
    package = (config.lib.nixGL.wrap pkgs.swayfx);
    checkConfig = false;
    config = {
      modifier = "Mod4";
    };
  };

  config.xdg.configFile = lib.mkIf config.pkgconfig.sway.enable (
    builtins.listToAttrs (
      lib.map (path: {
        name = "sway/scripts.d/${path}";
        value = {
          source = pkgs.substituteAll {
            src = ./scripts.d + "/${path}";
            env = {
              alacritty = lib.getExe config.programs.alacritty.package;
              cliphist = lib.getExe pkgs.cliphist;
              grim = lib.getExe pkgs.grim;
              imagemagick = pkgs.imagemagick;
              imv = (config.lib.nixGL.wrap pkgs.imv);
              jq = lib.getExe pkgs.jq;
              mako = pkgs.mako;
              slurp = lib.getExe pkgs.slurp;
              swappy = lib.getExe pkgs.swappy;
              tesseract = lib.getExe pkgs.tesseract;
              tmux = lib.getExe pkgs.tmux;
              trans = lib.getExe pkgs.translate-shell;
              wl_clipboard = pkgs.wl-clipboard;
              wofi = lib.getExe pkgs.wofi;
              wtype = lib.getExe pkgs.wtype;
            };
          };
          executable = true;
        };
      }) (builtins.attrNames (builtins.readDir ./scripts.d))
    )
  );

  imports = [
    ./conf.d/colors.nix
    ./conf.d/input.nix
    ./conf.d/keybinds.nix
    ./conf.d/outputs.nix
    ./conf.d/settings.nix
    ./conf.d/startup.nix
  ];
}
