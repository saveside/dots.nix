{ pkgs, ... }:

{
  home.packages = [ pkgs.vicinae ];

  # ~/.config/vicinae/vicinae.json — points theme at the pure-black theme below.
  xdg.configFile."vicinae/vicinae.json".text = builtins.toJSON {
    "$schema" = "https://vicinae.com/schemas/config.json";
    theme = {
      light = {
        name = "pure-black";
        icon_theme = "auto";
      };
      dark = {
        name = "pure-black";
        icon_theme = "auto";
      };
    };
    font.normal.family = "auto";
    launcher_window = {
      material = "none";
      client_side_decorations.enabled = true;
    };
  };

  # Pure-black theme — mono palette, everything derives from core.
  xdg.configFile."vicinae/themes/pure-black.toml".text = ''
    [meta]
    name = "Pure Black"
    description = "Monochrome pitch-black palette"
    variant = "dark"

    [colors.core]
    background = "#000000"
    secondary_background = "#0a0a0a"
    foreground = "#ffffff"
    border = "#1a1a1a"
    accent = "#ffffff"
    accent_foreground = "#000000"

    [colors.accents]
    blue    = "#ffffff"
    green   = "#ffffff"
    magenta = "#ffffff"
    orange  = "#ffffff"
    purple  = "#ffffff"
    red     = "#ff5555"
    yellow  = "#ffffff"
    cyan    = "#ffffff"

    [colors.text]
    default     = "#ffffff"
    muted       = "#808080"
    placeholder = "#606060"
    danger      = "#ff5555"
    success     = "#ffffff"

    [colors.input]
    border       = "#1a1a1a"
    border_focus = "#ffffff"
    border_error = "#ff5555"
  '';

  # Systemd user unit — starts with graphical-session.target (sway/hyprland pull it in).
  systemd.user.services.vicinae = {
    Unit = {
      Description = "Vicinae Launcher Daemon";
      Documentation = [ "https://docs.vicinae.com" ];
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      Requires = [ "dbus.socket" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.vicinae}/bin/vicinae server --replace";
      Restart = "always";
      RestartSec = 60;
      KillMode = "process";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
