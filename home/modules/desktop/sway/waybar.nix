{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 38;
        spacing = 4;
        
        modules-left = [
          "sway/workspaces"
          "mpris"
          "custom/media"
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
          "battery"
          "group/tray-expander"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "sway/window" = {
          format = "{}";
          empty-format = "";
          separate-outputs = true;
          max-length = 50;
          tooltip = false;
        };

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "▶";
          };
          status-icons = {
            paused = "⏸";
          };
          max-length = 30;
        };

        "hyprland/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "hyprland/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [
            ""
            ""
          ];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        tray = {
          spacing = 10;
        };

        "custom/tray-expand-icon" = {
          format = " ";
          tooltip = false;
        };

        "group/tray-expander" = {
          drawer = {
            transition-duration = 325;
          };
          modules = [
            "custom/tray-expand-icon"
            "tray"
          ];
          orientation = "inherit";
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "e{capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          on-click = "ags -t quicksettings";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = " {icon} {volume}%";
          format-bluetooth-muted = " ";
          format-muted = "";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        "custom/vpn" = {
          tooltip = true;
          format = "VPN {}";
          return-type = "json";
          exec = "if ivpn status | grep -q ' : CONNECTED'; then LOCATION=$(ivpn status | awk -F', ' 'NR==2 {print $2 \", \" $3}'); echo \"{\\\"text\\\": \\\"\\\", \\\"class\\\": \\\"connected\\\", \\\"tooltip\\\": \\\"$LOCATION\\\"}\"; else echo '{\"text\": \"\", \"class\": \"disconnected\", \"tooltip\": \"Disconnected\"}'; fi";
          interval = 1;
          on-click = "ivpn connect -any";
          on-click-right = "ivpn disconnect";
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = "⬇{bandwidthDownBytes} ⬆{bandwidthUpBytes}";
          interval = 3;
          format-linked = "{ifname} (No IP) ";
          format = "";
          format-disconnected = "";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "wl-copy $(ip address show up scope global | grep inet | head -n1 | cut -d/ -f 1 | tr -d [:space:] | cut -c5-)";
        };
      };
    };

    style = ''
      * {
          font-family: "JetBrainsMono Nerd Font", proportional_font, monospace;
          font-size: 14px;
          min-height: 0;
          font-weight: bold;
      }

      window#waybar {
          background-color: #000000;
          color: #ffffff;
      }

      window#waybar.hidden {
        opacity: 0;
      }

      window#waybar.empty #window {
          background-color: transparent;
          border: none;
          padding: 0;
          margin: 0;
      }

      tooltip {
        background: #000000;
        border: 1px solid rgba(255, 255, 255, 0.3);
        padding: 8px 12px;
      }

      tooltip label {
        color: #ffffff;
        font-weight: 500;
      }

      #workspaces {
          margin: 4px 2px;
      }

      #window.empty {
          background-color: transparent;
          color: transparent;
          padding: 0;
          margin: 0;
          border: none;
      }

      #window,
      #mpris,
      #custom-media,
      #idle_inhibitor,
      #custom-vpn,
      #network,
      #pulseaudio,
      #clock,
      #battery,
      #group-tray-expander,
      #tray {
          background-color: #141414;
          color: #fffffe;
          border: 1px solid #2a2a2a;
          border-radius: 0;
          margin: 4px 2px;
          padding: 0 8px;
      }

      #workspaces button {
          background-color: #000000;
          color: #ffffff;
          border-radius: 0;
          margin: 0 2px;
          padding: 0 8px;
          border: none;
          transition: all 0.2s ease;
      }

      #workspaces button:hover {
          background-color: #333333;
          box-shadow: none;
      }

      #workspaces button.focused {
          background-color: #141414;
          border: 1px solid #2a2a2a;
          color: #ffffff;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
          color: #ffffff;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      #idle_inhibitor.activated {
          background-color: #eb4d4b;
          color: #ffffff;
      }

      #battery.charging,
      #battery.plugged {
          background-color: #7cb342;
          color: #000000;
          animation-name: none;
      }

      #battery.critical:not(.charging) {
          background-color: #eb4d4b;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #eb4d4b;
          }
      }
    '';
  };
}
