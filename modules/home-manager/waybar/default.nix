{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.waybar;
in
{
  options.moduleopts.waybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Waybar";
    };
    weather_location = lib.mkOption {
      default = "Istanbul";
      type = lib.types.str;
      description = "The location for the weather module.";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = config.wrapped.waybar;

      settings = {
        mainBar = {
          height = 32;
          spacing = 0;
          modules-left = [
            "hyprland/workspaces"
            "custom/media"
          ];
          modules-center = [
            "hyprland/window"
          ];
          modules-right = [
            "custom/swaync"
            "idle_inhibitor"
            "custom/vpn"
            "network"
            "pulseaudio"
            "clock"
            "clock#date"
            "battery"
            "tray"
          ];
          "hyprland/mode" = {
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
          "hyprland/window" = {
            format = "{title}";
            empty-format = "No active window";
            on-click = "${lib.getExe pkgs.ags} -t datemenu";
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
            on-click = "${lib.getExe pkgs.ags} -t quicksettings";
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
            on-click = "${lib.getExe pkgs.pavucontrol}";
          };
          "custom/weather" = {
            format = "{}";
            interval = 3600;
            exec = "curl -s 'https://wttr.in/${cfg.weather_location}?format=1'";
            exec-if = "ping wttr.in -c1";
          };
          "custom/vpn" = {
            tooltip = false;
            format = "VPN {}";
            exec = "mullvad status | grep -q 'Connected' && echo ' ' || echo ' '";
            interval = 5;
            on-click = "mullvad connect";
            on-click-right = "mullvad disconnect";
          };
          "custom/swaync" = {
            tooltip = false;
            format = "{icon} {0}";
            format-icons = {
              notification = " ";
              none = " ";
              dnd-notification = " ";
              dnd-none = " ";
              inhibited-notification = " ";
              inhibited-none = " ";
              dnd-inhibited-notification = " ";
              dnd-inhibited-none = " ";
            };
            return-type = "json";
            exec-if = "${pkgs.swaynotificationcenter}/bin/swaync-client";
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
            on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
            escape = true;
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
        @define-color background #191724;
        @define-color foreground #e0def4;
        @define-color blue #908caa;
        @define-color cyan #9ccfd8;
        @define-color purple #c4a7e7;
        @define-color yellow #f6c177;
        @define-color green #9ccfd8;
        @define-color red #eb6f92;
        @define-color magenta #c4a7e7;
        * {
            font-family: ${config.stylix.fonts.sansSerif.name}, ${config.stylix.fonts.monospace.name}, sans-serif;
            font-size: ${builtins.toString (config.stylix.fonts.sizes.applications + 3)}px;
            font-weight: bold;
            min-height: 0;
            transition: none;
        }

        window#waybar {
            background: rgba(0, 0, 0, 0.6);
            color: @foreground;
            border-bottom: 2px solid alpha(@foreground, 0.15);
        }


        #pulseaudio,
        #clock,
        #battery,
        #network,
        #tray,
        #custom-swaync,
        #idle_inhibitor,
        #custom-vpn {
            margin-left: 2px;
            margin-right: 2px;
            padding: 1px 8px;
            transition: background-color 150ms ease;
        }

        #pulseaudio:hover,
        #clock:hover,
        #battery:hover,
        #network:hover,
        #tray:hover,
        #custom-swaync:hover,
        #idle_inhibitor:hover,
        #custom-vpn:hover {
            background-color: alpha(@foreground, 0.1);
        }

        #custom-swaync {
            color: @magenta;
        }

        #pulseaudio {
            color: @green;
        }

        #clock {
            color: @red;
        }

        #clock.date {
            color: @purple;
        }

        #network {
            color: @yellow;
        }

        #idle_inhibitor {
            padding: 2px 18px 2px 10px;
            color: @red;
        }

        #idle_inhibitor.activated {
            color: @green;
            animation: glow 2s infinite;
        }

        #battery.charging,
        #battery.plugged {
            color: @green;
        }

        #battery.warning {
            color: @yellow;
        }

        #battery.critical {
            color: @red;
            animation: blink 1s infinite;
        }

        #custom-vpn {
            color: @green;
        }

        #workspaces button {
            padding: 0 12px;
            margin-top: 2px;
            border-radius: 0;
            background-color: alpha(@background, 0.30);
            transition: background-color 150ms ease, color 150ms ease;
        }

        #workspaces button:hover {
            background-color: alpha(@foreground, 0.1);
        }

        #workspaces button.active {
            background-color: @foreground;
            color: @background;
        }

        #workspaces button.urgent {
            background-color: @red;
            animation: pulse 1s infinite;
        }

        @keyframes pulse {
            0% {
                opacity: 1;
            }

            50% {
                opacity: 0.7;
            }

            100% {
                opacity: 1;
            }
        }

        @keyframes glow {
            0% {
                box-shadow: 0 0 5px @green;
            }

            50% {
                box-shadow: 0 0 15px @red;
            }

            100% {
                box-shadow: 0 0 5px @red;
            }
        }

        @keyframes blink {
            0% {
                opacity: 1;
            }

            50% {
                opacity: 0.5;
            }

            100% {
                opacity: 1;
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
  };
}
