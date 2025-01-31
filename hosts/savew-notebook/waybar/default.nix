{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.pkgconfig.waybar = {
    enable = lib.mkEnableOption "Enable waybar configuration.";
    weather_location = lib.mkOption {
      type = lib.types.str;
      default = "Istanbul";
      description = "Weather location for waybar.";
    };
  };
  config.programs.waybar = {
    enable = config.pkgconfig.waybar.enable;
    package = config.wrappedPkgs.waybar;

    settings = {
      mainBar = {
        height = 32;
        spacing = 0;
        modules-left = [
          "sway/workspaces"
          "sway/media"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "idle_inhibitor"
          "custom/vpn"
          "network"
          "pulseaudio"
          "clock"
          "clock#date"
          "battery"
          "tray"
        ];
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [
            ""
            " "
          ];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };
        "sway/window" = {
          format = "{title}";
          empty-format = "No active window";
          on-click = "${pkgs.ags}/bin/ags -t datemenu";
          tooltip = false;
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "tray" = {
          spacing = 10;
        };
        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        "clock#date" = {
          format = "{:%d.%m.%Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [
            "  "
            "  "
            "  "
            "  "
            "  "
          ];
          on-click = "${pkgs.ags}/bin/ags -t quicksettings";
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = " {icon} {volume}% {format_source}";
          format-bluetooth-muted = "  {icon} {format_source}";
          format-muted = "  {format_source}";
          format-source = " {volume}%";
          format-source-muted = " ";
          format-icons = [
            " "
            " "
            " "
          ];
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "custom/weather" = {
          format = "{}";
          interval = 3600;
          exec = "curl -s 'https://wttr.in/${config.pkgconfig.waybar.weather_location}?format=1'";
          exec-if = "ping wttr.in -c1";
        };
        "custom/vpn" = {
          tooltip = false;
          format = "VPN {}";
          exec = "mullvad status | grep -q 'Connected' && echo ' ' || echo ' '";
          interval = 5;
          on-click = "mullvad connect";
          on-click-right = "mullvad disconnect";
        };
        "network" = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "⬇{bandwidthDownBytes} ⬆{bandwidthUpBytes}";
          interval = 3;
          format-linked = "{ifname} (No IP)  ";
          format = " ";
          format-disconnected = " ";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "${pkgs.wl-clipboard}/bin/wl-copy $(ip address show up scope global | grep inet | head -n1 | cut -d/ -f 1 | tr -d [:space:] | cut -c5-)";
          tooltip-format = "  {bandwidthUpBits}  {bandwidthDownBits}\n{ifname}\n{ipaddr}/{cidr}\n";
          tooltip-format-wifi = "  {essid} {frequency}MHz\nStrength: {signaldBm}dBm ({signalStrength}%)\nIP: {ipaddr}/{cidr}\n {bandwidthUpBits}  {bandwidthDownBits}";
          min-length = 17;
          max-length = 17;
        };
      };
    };
    style = ''
      /*
      *
      * Cosmic Midnight Palette
      *
      */

      @define-color background #1b1b1b;
      @define-color foreground #e0e0e0;
      @define-color lighter #282828;

      /* Normal */
      @define-color black #1b1b1b;
      @define-color magenta #d16d92;
      @define-color green #50a664;
      @define-color yellow #dbb400;
      @define-color blue #6f92ff;
      @define-color red #ff6b81;
      @define-color cyan #4fb3c5;
      @define-color white #f0f0f0;
      @define-color orange #eaa560;
      @define-color purple #a87dbb;

      /* misc */
      @define-color hover #9ab0c9;


      * {
          font-family: "Roboto", sans-serif;
          font-size: 12px;
          font-weight: bold;
          min-height: 0;
          transition: none;
      }

      window#waybar {
          background: transparent;
          color: @foreground;
          padding: 0;
          margin: 0;
      }

      window#waybar.empty #window {
          background: transparent;
          box-shadow: 0px 0px 0px;
      }

      #window {
          margin-top: 4px;
          padding: 6px 12px;
          border-radius: 12px;
          background-color: alpha(@background, 0.90);
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      #pulseaudio,
      #clock,
      #battery,
      #network,
      #tray,
      #idle_inhibitor,
      #custom-vpn {
          margin-top: 4px;
          margin-left: 4px;
          margin-right: 4px;
          padding: 2px 16px;
          border-radius: 8px;
          background-color: alpha(@background, 0.90);
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
          border-width: 2px;
          border-style: solid;
      }

      #idle_inhibitor {
          padding: 2px 15px 2px 10px;
      }

      #pulseaudio {
          color: @blue;
          border-color: alpha(@blue, 1);
      }

      #clock {
          color: @cyan;
          border-color: alpha(@cyan, 1);
      }

      #clock.date {
          color: @purple;
          border-color: alpha(@purple, 1);
      }

      #network {
          color: @yellow;
          border-color: alpha(@yellow, 1);
      }

      #tray {
          border-color: alpha(@foreground, 1);
      }

      #idle_inhibitor {
          color: @green;
          border-color: alpha(@green, 1);
      }

      #idle_inhibitor.activated {
          color: @red;
          border-color: alpha(@red, 1);
          animation: glow 2s infinite;
      }

      #battery {
          border-color: alpha(@foreground, 1);
      }

      #battery.charging,
      #battery.plugged {
          color: @green;
          border-color: alpha(@green, 1);
      }

      #battery.warning {
          color: @yellow;
          border-color: alpha(@yellow, 1);
      }

      #battery.critical {
          color: @red;
          border-color: alpha(@red, 1);
          animation: blink 1s infinite;
      }

      #custom-vpn {
          color: @magenta;
          border-color: alpha(@magenta, 1);
      }

      #workspaces button {
          padding: 0 12px;
          margin-top: 4px;
          border-radius: 0;
          background-color: alpha(@background, 0.90);
          transition: background-color 150ms ease, color 150ms ease;
      }

      #workspaces button:hover {
          background-color: alpha(@foreground, 0.1);
          box-shadow: inset 0 -2px @foreground;
      }

      #workspaces button:first-child {
          border-top-left-radius: 8px;
          border-bottom-left-radius: 8px;
          margin-left: 4px;
      }

      #workspaces button:last-child {
          border-top-right-radius: 8px;
          border-bottom-right-radius: 8px;
      }

      #workspaces button.focused {
          background-color: @foreground;
          color: @background;
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      #workspaces button.urgent {
          background-color: @red;
          animation: pulse 1s infinite;
      }

      /* Animations */
      @keyframes pulse {

          0% {
              opacity: 1;
          }

          100% {
              opacity: 1;
          }

          50% {
              opacity: 0.7;
          }
      }

      @keyframes glow {

          0% {
              box-shadow: 0 0 5px @green;
          }

          100% {
              box-shadow: 0 0 5px @red;
          }

          50% {
              box-shadow: 0 0 15px @red;
          }
      }

      @keyframes blink {

          0% {
              opacity: 1;
          }

          100% {
              opacity: 1;
          }

          50% {
              opacity: 0.5;
          }
      }

      .modules-left>widget:first-child>#workspaces {
          margin-left: 0;
      }

      .modules-right>widget:last-child>#workspaces {
          margin-right: 0;
      }
    '';

  };
}
