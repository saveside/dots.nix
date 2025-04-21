{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.hyprland;
in
{
  options.moduleopts.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Hyprland";
    };
  };
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        "$mod" = "SUPER";
        "$alt" = "ALT";

        env = [
          "HYPRCURSOR_THEME,${config.stylix.cursor.name}"
          "HYPRCURSOR_SIZE,${builtins.toString config.stylix.cursor.size}"
        ];
      };
    };

    xdg.configFile = (
      builtins.listToAttrs (
        lib.map (path: {
          name = "hypr/scripts.d/${path}";
          value = {
            source = pkgs.substituteAll {
              src = ./scripts.d + "/${path}";
              env = {
                alacritty = lib.getExe config.wrapped.alacritty;
                bash = lib.getExe pkgs.bash;
                cliphist = lib.getExe pkgs.cliphist;
                grim = lib.getExe pkgs.grim;
                hyprland = config.wrapped.hyprland;
                imagemagick = config.wrapped.imagemagick;
                imv = config.wrapped.imv;
                jq = lib.getExe pkgs.jq;
                mako = pkgs.mako;
                ncmpcpp = lib.getExe pkgs.ncmpcpp;
                notify-send = lib.getExe pkgs.libnotify;
                slurp = lib.getExe pkgs.slurp;
                swappy = lib.getExe pkgs.swappy;
                sway = config.wrapped.sway;
                swaync = lib.getExe pkgs.swaynotificationcenter;
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
  };

  imports = lib.map (p: ./config.d + "/${p}") (
    lib.remove "default.nix" (builtins.attrNames (builtins.readDir ./config.d))
  );
}
