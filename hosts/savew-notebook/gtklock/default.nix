{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.pkgconfig.gtklock = {
    enable = lib.mkEnableOption "Enable gtklock configuration.";
  };

  config.xdg.configFile."gtklock/config.ini".text = lib.mkIf config.pkgconfig.gtklock.enable ''
    [main]
    modules=${pkgs.gtklock-powerbar-module}/lib/gtklock/powerbar-module.so
    time-format= %A, %b %d  %I:%M %p

    [userinfo]
    under-clock=true
    image-size=128
  '';
  config.xdg.configFile."gtklock/style.css".text = lib.mkIf config.pkgconfig.gtklock.enable ''
    /* Material Design inspired color palette */
    @define-color background #121212;
    @define-color foreground #fafafa;
    @define-color surface #1e1e1e;
    @define-color primary #7289da;
    @define-color secondary #4fb3c5;
    @define-color accent #50a664;
    @define-color error #ff5252;
    @define-color hover rgba(255, 255, 255, 0.1);

    /* Transitions */
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
      transition: all 200ms ease;
    }

    window {
      background-color: transparent;
      background-size: cover;
      background-repeat: no-repeat;
      background-position: center;
      background-image: url("file://${../bin/lockscreen.png}"); 
      animation: fadeIn 400ms ease;
    }

    #window-box,
    #playerctl-revealer>box,
    #powerbar-revealer>box {
      color: @foreground;
      background-color: alpha(@background, 0.85);
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
      padding: 2em 3em;
      border: 1px solid alpha(@surface, 0.5);
    }

    #playerctl-revealer>box,
    #powerbar-revealer>box {
      padding: 0.7em;
      margin: 0.8em 0;
      background-color: alpha(@surface, 0.95);
    }

    #clock-label {
      min-width: 320px;
      background: linear-gradient(135deg, alpha(@accent, 0.1), alpha(@secondary, 0.1));
      color: @accent;
      font-weight: 600;
      font-size: 10pt;
      padding: 12px 30px;
      margin-bottom: 15px;
      border-radius: 8px;
      border: 1px solid alpha(@accent, 0.3);
      letter-spacing: 0.5px;
    }

    .image-button {
      padding: 0.8em;
      border-radius: 50%;
      background-color: alpha(@hover, 0.05);
    }

    .image-button:hover {
      background-color: alpha(@hover, 0.15);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }

    #user-name {
      font-size: 18pt;
      font-weight: 500;
      margin: 10px 0;
      color: @foreground;
    }

    #input-field {
      border-radius: 25px;
      padding: 12px 20px;
      background-color: alpha(@surface, 0.6);
      border: 2px solid alpha(@primary, 0.3);
      margin: 10px 0;
    }

    #input-field:focus {
      border-color: @primary;
      background-color: alpha(@surface, 0.8);
      box-shadow: 0 0 0 2px alpha(@primary, 0.2);
    }

    #warning-label,
    #error-label,
    #unlock-button {
      margin: 15px 0;
      padding: 12px 30px;
      border-radius: 25px;
    }

    #unlock-button {
      background: linear-gradient(135deg, @accent, alpha(@secondary, 0.8));
      color: @foreground;
      font-weight: 500;
      box-shadow: 0 2px 10px alpha(@accent, 0.3);
    }

    #unlock-button:hover {
      box-shadow: 1 4px 15px alpha(@accent, 0.4);
    }
  '';
}
