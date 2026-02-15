# Waybar configuration
{ ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 48;
        spacing = 0;
        reload_style_on_change = true;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "clock"
          "network"
          "custom/vpn"
          "pulseaudio"
          "battery"
          "idle_inhibitor"
          "group/tray-expander"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
        };

        "hyprland/window" = {
          format = "{}";
          empty-format = "Desktop";
          separate-outputs = true;
          max-length = 50;
        };

        "clock" = {
          format = "{:%H:%M  %a %d %b}";
          format-alt = "{:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "{icon}󱐋 {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip = true;
        };

        "network" = {
          "format-wifi" = "󰤟   {essid}";
          "format-ethernet" = "󰈀 {bandwidthDownBytes}  {bandwidthUpBytes}";
          "interval" = 3;
          "format-linked" = "{ifname} (No IP) ";
          "format" = "";
          "format-disconnected" = "󰤟 ";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          "on-click" = ''wl-copy $(ip address show up scope global | grep inet | head -n1 | cut -d/ -f 1 | tr -d [:space:] | cut -c5-)'';
          "tooltip-format" = " {bandwidthUpBits}  {bandwidthDownBits}\n{ifname}\n{ipaddr}/{cidr}";
          "tooltip-format-wifi" = "󰤟 {essid} {frequency}MHz\nStrength: {signaldBm}dBm ({signalStrength}%)\nIP: {ipaddr}/{cidr}\n {bandwidthUpBits}  {bandwidthDownBits}";
          "max-length" = 15;
        };

        "pulseaudio" = {
          "format" = "{icon} {volume}%";
          "format-bluetooth" = "󰂰  {volume}%";
          "format-bluetooth-muted" = "󰂰󰖁 ";
          "format-muted" = "󰖁 ";
          "format-source" = " micrófono";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "󰋋";
            "headset" = "󰋋";
            "default" = [
              "󰕾"
              "󰖀"
              "󰕾"
            ];
            "bluetooth" = "󰂰";
            "phone" = "󰂰";
          };
          "on-click" = "pavucontrol";
          "tooltip-format" = "Volume: {volume}%\nClick to open mixer";
        };

        "custom/vpn" = {
          format = "{}";
          exec = "mullvad status | grep -q 'Connected' && echo '{\"text\":\"󱚿\",\"class\":\"connected\"}' || echo '{\"text\":\"󱛀\",\"class\":\"disconnected\"}'";
          return-type = "json";
          interval = 5;
          on-click = "mullvad connect";
          on-click-right = "mullvad disconnect";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "󰾪";
          };
        };

        "tray" = {
          spacing = 12;
          icon-size = 18;
        };

        "custom/tray-expand-icon" = {
          "format" = " ";
          "tooltip" = false;
        };

        "group/tray-expander" = {
          "drawer" = {
            "transition-duration" = 325;
          };
          "modules" = [
            "custom/tray-expand-icon"
            "tray"
          ];
          "orientation" = "inherit";
        };
      };
    };

    style = ''
      /* Zinc Theme Variables */
      @define-color background #0a0a0a;
      @define-color on_background #dde1e6;
      @define-color outline #525252;
      @define-color module_bg #212121;
      @define-color module_bg_hover #323232;
      @define-color tooltip_bg #161616;
      @define-color tooltip_text #dde1e6;
      @define-color text_primary #dde1e6;
      @define-color text_muted #a8a8a8;
      @define-color text_bright #f4f4f5;
      @define-color text_disabled #a1a1aa;
      @define-color state_active #71717a;
      @define-color state_urgent #a1a1aa;
      @define-color state_hover #525252;
      @define-color accent_red #ef4444;

      * {
        font-family: "SFProText Nerd Font";
        font-weight: 600;
        font-size: 13px;
        color: @on_background;
        border: none;
        padding: 0;
        margin: 0;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      }

      window#waybar {
        background: rgba(0, 0, 0, 0.85);
        border-bottom: 1px solid rgba(82, 82, 82, 0.3);
      }

      #workspaces {
        background: rgba(33, 33, 33, 0.6);
        border-radius: 8px;
        margin: 6px 4px 6px 10px;
        border: 1px solid rgba(82, 82, 82, 0.4);
      }

      #workspaces button {
        color: @text_muted;
        padding: 5px 8px;
      }

      #workspaces button.active {
        background: rgba(113, 113, 122, 0.4);
        color: @text_bright;
      }

      #clock, #tray, #network, #custom-vpn, #pulseaudio, #battery, #idle_inhibitor {
        background: rgba(33, 33, 33, 0.6);
        border: 1px solid rgba(82, 82, 82, 0.4);
        padding: 5px 12px;
        margin: 6px 3px;
        border-radius: 8px;
      }

      #pulseaudio.muted { color: @text_disabled; }
      #battery.critical { color: @accent_red; }
      #custom-vpn.connected { color: @accent_red; }
    '';
  };
}
