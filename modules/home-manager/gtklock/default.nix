{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.gtklock;
in
{
  options.moduleopts.gtklock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "gtklock";
    };
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."gtklock/config.ini".text = ''
      [main]
      modules=${pkgs.gtklock-powerbar-module}/lib/gtklock/powerbar-module.so
      time-format=   %I:%M %p

      [userinfo]
      under-clock=false
      image-size=128
    '';
    xdg.configFile."gtklock/style.css".text = ''
        @define-color background ${config.lib.stylix.colors.withHashtag.base00};
        @define-color foreground ${config.lib.stylix.colors.withHashtag.base05};
        @define-color active ${config.lib.stylix.colors.withHashtag.base0D};
        @define-color inactive ${config.lib.stylix.colors.withHashtag.base03};     
        @define-color inactive2 ${config.lib.stylix.colors.withHashtag.base03};
        @define-color primary ${config.lib.stylix.colors.withHashtag.base05};
        @define-color destructive ${config.lib.stylix.colors.withHashtag.base0C};

      @keyframes fadeIn {
        from {
          opacity: 0;
        }

        to {
          opacity: 1;
        }
      }

      * {
        all: unset;
        transition: all 150ms ease-in-out;
      }

      window {
        background-color: @background;
        animation: fadeIn 400ms ease;
      }

      #window-box,
      #playerctl-revealer>box,
      #powerbar-revealer>box {
        color: @foreground;
        background-color: @background;     
        border: 2px solid @active;
        border-radius: 12px;
        padding: 2em 3em;     
      }

      #playerctl-revealer>box,
      #powerbar-revealer>box {
        padding: 0.7em;
        margin: 0.8em 0;
        background-color: @background;
      }

      #clock-label {
        min-width: 320px;
        color: @active;
        font-weight: 500;
        font-size: 14pt;
        padding: 8px 16px;
        margin-bottom: 12px;     
        letter-spacing: 0.5px;
      }

      .image-button {
        padding: 0.8em;     
        background-color: transparent;
      }

      .image-button:hover {
        background-color: alpha(@foreground, 0.05);
      }

      #user-name {
        font-size: 18pt;
        font-weight: 500;
        margin: 10px 0;
        color: @foreground;
      }

      #input-field {     
        padding: 10px 12px;
        background-color: @background;
        border: 2px solid @active;
        border-radius: 16px;
        margin: 10px 0;
      }

      #input-field:focus {     
        box-shadow: 0 0 0 2px alpha(@primary, 0.2);
      }

      #warning-label,
      #error-label,
      #unlock-button {
        margin: 15px 0;
        padding: 10px 24px;     
      }

      #unlock-button {
        background-color: @active;
        border-radius: 12px;
        color: @background;
        font-weight: 500;
      }

      #unlock-button:hover {
        background-color: alpha(@primary, 0.9);
      }

      #error-label {
        color: @destructive;
      }
    '';
  };
}
