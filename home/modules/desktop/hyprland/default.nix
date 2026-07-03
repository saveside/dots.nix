{ vars, config, ... }:

{
  imports = [
    ./settings.nix
    ./keybinds.nix
    ./rules.nix
    ./startup.nix
    ./hypridle.nix
    ./hyprlock.nix
    #./hyprsunset.nix
  ];

  xdg.configFile."hypr/modules/colors.conf".source = ./colors.nix;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    configType= "hyprlang";
    settings = {
      source = [ "${config.xdg.configHome}/hypr/modules/colors.conf" ];
      "$mod" = "SUPER";
      "$alt" = "ALT";
      debug.disable_logs = false;

      # Monitor configuration from vars.nix
      monitor = map (
        m:
        if m.disabled then
          "${m.name}, disabled"
        else
          "${m.name}, ${toString m.width}x${toString m.height}@${toString m.refresh}, ${m.position}, ${toString m.scale}"
      ) vars.monitors;

      "$scr1" = (builtins.elemAt vars.monitors 0).name;

      input = {
        kb_layout = "tr";
        numlock_by_default = true;
        kb_options = "grp:win_space_toggle";

        touchpad = {
          disable_while_typing = true;
          tap-to-click = true;
          natural_scroll = false;
          middle_button_emulation = true;
        };
      };

      env = [
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "SDL_VIDEODRIVER,wayland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "SSH_AUTH_SOCK,/run/user/1000/keyring/ssh"
        "GNOME_KEYRING_CONTROL,/run/user/1000/keyring"
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "XCURSOR_SIZE,24"
      ];
    };
  };
}
