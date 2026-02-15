# SwayNC notification center configuration
{ pkgs, ... }:

{
  services.swaync = {
    enable = true;

    settings = {
      "$schema" = "${pkgs.swaynotificationcenter}/etc/swaync/configSchema.json";
      control-center-height = 2;
      control-center-layer = "overlay";
      control-center-margin-bottom = 20;
      control-center-margin-left = 0;
      control-center-margin-right = 10;
      control-center-margin-top = 20;
      control-center-width = 500;
      cssPriority = "application";
      control-center-positionX = "right";
      control-center-positionY = "center";
      fit-to-screen = true;
      hide-on-action = false;
      hide-on-clear = true;
      image-visibility = "when-available";
      keyboard-shortcuts = true;
      layer = "overlay";
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

      widgets = [
        "title"
        "notifications"
        "buttons-grid"
        "mpris"
        "dnd"
        "volume"
      ];

      widget-config = {
        title = {
          text = "   Notifications";
          button-text = "󰎟  Clear";
          clear-all-button = true;
        };
        dnd = {
          text = "Do Not Disturb";
        };
        mpris = {
          image-radius = 3;
          image-size = 96;
        };
        notifications = {
          clear-all-button = true;
        };
        volume = {
          label = " ";
          show-per-app = true;
          show-per-app-icon = true;
          show-per-app-label = true;
        };
        buttons-grid = {
          actions = [
            {
              label = " ";
              type = "toggle";
              active = false;
              command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && nmcli radio wifi on || nmcli radio wifi off'";
              update-command = "sh -c '[[ $(nmcli radio wifi) == \"enabled\" ]] && echo true || echo false'";
            }
            {
              label = "";
              type = "toggle";
              active = false;
              command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && rfkill unblock bluetooth || rfkill block bluetooth'";
              update-command = "sh -c '[[ $(rfkill list bluetooth | grep \"Soft blocked: yes\") ]] && echo false || echo true'";
            }
            {
              label = "󰄀";
              type = "button";
              active = false;
              command = "hyprshot -m region";
            }
            {
              label = "󰕧";
              type = "toggle";
              active = false;
              command = "sh -c ~/script/swaync/wf-recorder.sh";
              update-command = "sh -c 'pgrep -x wf-recorder > /dev/null && echo true || echo false'";
            }
            {
              label = "";
              type = "button";
              active = true;
              command = "sh -c ~/script/cliphist/cliphist-menu.sh";
            }
          ];
        };
      };
    };

    style = ''
      /* shadcn/ui-inspired SwayNC Theme */
      @define-color bg-900 #09090b;
      @define-color bg-800 #18181b;
      @define-color bg-700 #27272a;
      @define-color bg-600 #3f3f46;
      @define-color bg-500 #52525b;
      @define-color fg-100 #fafafa;
      @define-color fg-300 #d4d4d8;
      @define-color fg-400 #a1a1aa;
      @define-color fg-500 #71717a;
      @define-color accent-blue #3b82f6;
      @define-color accent-blue-soft #a1c3ff;
      @define-color accent-red #ef4444;
      @define-color accent-red-soft #fca5a5;
      @define-color shadow-strong rgba(0, 0, 0, 0.3);
      @define-color shadow-soft rgba(0, 0, 0, 0.3);

      * {
        font-family: "SF Pro", "Inter", system-ui, -apple-system, sans-serif;
        transition: all 150ms cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: none;
        border-radius: 0;
      }

      .notification-background .notification {
        margin: 0; padding: 0;
        background-color: @bg-900;
        border: none; border-radius: 0;
      }
      .notification-content {
        padding: 1rem 1.25rem;
        background-color: @bg-800;
        border-left: 2px solid @accent-blue;
        box-shadow: 0 1px 3px 0 @shadow-strong;
      }
      .notification.critical .notification-content {
        border-left: 2px solid @accent-red;
      }
      .notification .summary {
        font-size: 1rem; font-weight: 650;
        color: @fg-100;
      }
      .notification .body {
        font-size: 0.95rem; color: @fg-400;
      }

      .control-center {
        background-color: @bg-900;
        border: 1px solid @bg-700;
        padding: 1rem;
      }
      .widget-title label {
        font-weight: 600; font-size: 1.25rem;
        color: @fg-100;
      }
      .widget-buttons-grid button {
        background-color: @bg-900;
        border: 1px solid @bg-700;
      }
      .widget-buttons-grid button:checked {
        background-color: @accent-blue;
      }
    '';
  };
}
