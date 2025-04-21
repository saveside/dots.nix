{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.swaync;
in
{
  options.moduleopts.swaync = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Swaync";
    };
  };
  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;
      settings = {
        "$schema" = "${pkgs.swaynotificationcenter}/swaync/configSchema.json";
        control-center-height = 2;
        control-center-layer = "overlay";
        control-center-margin-bottom = 20;
        control-center-margin-left = 0;
        control-center-margin-right = 10;
        control-center-margin-top = 20;
        control-center-positionX = "right";
        control-center-positionY = "center";
        control-center-width = 500;
        cssPriority = "application";
        fit-to-screen = true;
        hide-on-action = false;
        hide-on-clear = true;
        image-visibility = "when-available";
        keyboard-shortcuts = true;
        layer = "layer";
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        notification-icon-size = 40;
        notification-inline-replies = true;
        notification-visibility = { };
        notification-window-width = 400;
        positionX = "right";
        positionY = "top";
        script-fail-notify = true;
        scripts = { };
        timeout = 10;
        timeout-critical = 0;
        timeout-low = 5;
        transition-time = 100;
        widget-config = {
          buttons-grid = {
            actions = [
              {
                label = " ";
                type = "toggle";
                active = false;
                command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && nmcli radio wifi on || nmcli radio wifi off'";
                update-command = "sh -c '[[ $(nmcli radio wifi) == \"enabled\" ]] && echo true || echo false'";
              }
              {
                label = "";
                type = "toggle";
                active = false;
                command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && rfkill unblock bluetooth || rfkill block bluetooth'";
                update-command = "sh -c '[[ $(rfkill list bluetooth | grep \"Soft blocked: yes\") ]] && echo false || echo true'";
              }
              {
                active = false;
                command = "hyprshot -m region";
                label = "󰄀";
                type = "button";
              }
              {
                label = "󰕧";
                type = "toggle";
                active = false;
                command = "sh -c ${config.home.homeDirectory}/.config/swaync/wf-recorder.sh";
                update-command = "sh -c 'pgrep -x wf-recorder > /dev/null && echo true || echo false'";
              }
              {
                active = true;
                command = "sh -c ${config.home.homeDirectory}/.config/swaync/cliphist-menu.sh";
                label = "";
                type = "button";
              }
            ];
          };
          mpris = {
            image-radius = 12;
            image-size = 96;
          };
          title = {
            text = "  Notifications";
            button-text = "󰎟  Clear";
            clear-all-button = true;
          };
          volume = {
            label = " ";
            show-per-app = true;
            show-per-app-icon = true;
            show-per-app-label = true;
          };
        };

        widgets = [
          "title"
          "buttons-grid"
          "mpris"
          "dnd"
          "notifications"
          "volume"
        ];

      };
      style = ''
        @define-color background ${config.colors.backgroundColor};
        @define-color foreground ${config.colors.textColor};
        @define-color active ${config.colors.activeColor};
        @define-color inactive ${config.colors.inactiveColor};     
        @define-color inactive2 ${config.colors.inactiveColor2};
        @define-color primary ${config.lib.stylix.colors.withHashtag.base05};
        @define-color destructive ${config.colors.urgentColor};


        * {
          font-family: "${config.stylix.fonts.sansSerif.name}";
          transition: 200ms;
          box-shadow: none;
        }

        .notification-background .notification {
          margin-bottom: 0.4rem;
          border: 0;
          border-radius: 0.8rem;
          -gtk-outline-radius: 0.8rem;
          transition: transform 200ms ease;
        }

        .notification-background .notification:hover {
          background-color: rgba(255, 255, 255, 0.02);
        }

        .notification-content {
          padding: 1rem 1.2rem;
          background-color: alpha(#000000, .55);
          border-bottom: 2px solid @active;
        }

        .notification.low .notification-content label,
        .notification.normal .notification-content label,
        .notification.low .notification-content image,
        .notification.normal .notification-content image {
          color: @inactive;
        }

        .notification.low .notification-content .body,
        .notification.normal .notification-content .body {
          color: @inactive2;
        }

        .notification.critical .notification-content {
          background-color: @background;
          border-bottom: 2px solid @urgent;
        }

        .notification.critical .notification-content label {
          color: @urgent;
        }

        .notification .summary,
        .notification .time,
        .notification .body {
          font-family: "${config.stylix.fonts.sansSerif.name}";
        }

        .notification .summary {
          font-size: 1.1rem;
          font-weight: 600;
          margin-bottom: 0.3rem;
        }

        .notification .time {
          font-size: 0.85rem;
          font-weight: 500;
          margin-right: 2.4rem;
          color: @inactive2;
        }

        .notification .body {
          font-size: 0.95rem;
          font-weight: 400;
          margin-top: 0.4rem;
        }

        /* Close Button */
        .close-button {
          background: none;
          border: none;
          border-radius: 1rem;
          box-shadow: none;
          margin: 4px 10px 0 0;
          padding: 4px 8px;
          min-height: 24px;
          min-width: 24px;
          text-shadow: none;
          color: @inactive;
        }

        .close-button:hover {
          background-color: rgba(255, 255, 255, 0.1);
          color: @active;
        }

        .close-button:active {
          background-color: rgba(255, 255, 255, 0.15);
          color: @active;
        }

        /* Control Center */
        .control-center {
          border-radius: 1.2rem;
          -gtk-outline-radius: 1.2rem;
          box-shadow: 0 3px 5px rgba(0, 0, 0, 0.5);
          margin: 8px;
          background-color: alpha(#000000, .55);
          padding: 1.2rem;
        }

        .control-center slider {
          background-color: rgba(42, 39, 63, 0.2);
          border-radius: 1rem;
        }

        .control-center slider:hover {
          background-color: rgba(42, 39, 63, 0.3);
        }

        .control-center slider:active {
          background-color: @active;
        }

        /* Widget Titles */
        .widget-title {
          padding: 0.5rem;
          margin-bottom: 0.8rem;
        }

        .widget-title label {
          font-family: "${config.stylix.fonts.sansSerif.name}";
          font-weight: 600;
          font-size: 1.4rem;
          color: @text;
          margin-left: 1rem;
        }

        .widget-title button {
          background: none;
          border: none;
          border-radius: 1.16rem;
          -gtk-outline-radius: 1.16rem;
          padding: 0.14rem;
          margin-left: 2rem;
        }

        .widget-title button label {
          font-family: "${config.stylix.fonts.sansSerif.name}", sans-serif;
          font-size: 1.04rem;
          color: @text;
          margin-right: 0.84rem;
        }

        .widget-title button:hover {
          background-color: rgba(43, 39, 63, 0.3);
        }

        .widget-title button:active {
          background-color: rgba(43, 39, 63, 0.7);
        }

        /* Widget Buttons */
        .widget-buttons-grid {
          border-radius: 1rem;
          -gtk-outline-radius: 1rem;
          background-color: alpha(#000000, .55);
          padding: 0.8rem;
        }

        .widget-buttons-grid button {
          background: none;
          border: none;
          border-radius: 0.8rem;
          min-width: 4.8rem;
          min-height: 3.2rem;
          padding: 0;
          margin: 0.2rem;
        }

        .widget-buttons-grid button label {
          font-family: "${config.stylix.fonts.sansSerif.name}";
          font-size: 1.3rem;
          color: @text;
        }

        .widget-buttons-grid button:hover {
          background-color: rgba(49, 39, 63, 0.3);
        }

        .widget-buttons-grid button:checked {
          background-color: alpha(#000000, .55);
          color: @text;
          box-shadow: 0 2px 3px rgba(0, 0, 0, 0.3);
        }

        /* Volume Widget */
        .widget-volume {
          background-color: alpha(#000000, .55);
          padding: 1rem;
          margin: 0.8rem;
          border-radius: 1rem;
        }
      '';
    };
    xdg.configFile = {
      "swaync/wf-recorder.sh" = {
        text = ''
          #!${lib.getExe pkgs.bash}
          echo wf-recorder
        '';
        executable = true;
      };
      "swaync/cliphist-menu.sh" = {
        text = ''
          #!${lib.getExe pkgs.bash}
          echo cliphist-menu
        '';
        executable = true;
      };
    };
  };
}
