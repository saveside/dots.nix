{ config, lib, pkgs, ... }:

let
  modifier = config.wayland.windowManager.hyprland.settings."$mod";
  alt = config.wayland.windowManager.hyprland.settings."$alt";
in
{
  wayland.windowManager.hyprland.settings = {
    binds = {
      workspace_back_and_forth = true;
    };
    bind = [

      "${modifier} SHIFT, r, exec, ${config.wrapped.hyprland}/bin/hyprctl reload"

      "${modifier} SHIFT, q, exec, ${lib.getExe config.wrapped.ags} -t powermenu"

      #~~~ user applications
      "${modifier}, return, exec, ${lib.getExe config.wrapped.alacritty} msg create-window"
      "${modifier}, e, exec, ${lib.getExe config.wrapped.pcmanfm-qt}"
      ", Print, exec, ${config.wrapped.flameshot} gui"
      "${modifier}, r, exec, ${lib.getExe pkgs.rofi} -show drun"
      "${modifier}, v, exec, ${lib.getExe config.wrapped.vscode} --ozone-platform=wayland"

      #~~~ audio
      "${alt}, up, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"
      "${alt}, down, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"
      "${modifier}, a, exec, ${config.home.homeDirectory}/.config/hypr/scripts.d/status.sh"
      ", XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"
      ", XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"
      ", XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
      ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
      ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"

      #~~~ brightness (for Laptops)
      ", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} set +5%"
      ", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} set 5%-"

      #~~~ misc utilities
      "${modifier}, m, exec, ${lib.getExe config.wrapped.ags} -t quicksettings"
      "${modifier}, k, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t"

      #~~~ window management
      "${modifier}, escape, workspace, previous"
      "${modifier} SHIFT, c, killactive"
      "${modifier}, right, exec, workspace, next"
      "${modifier}, left, exec, workspace, prev"
      "${modifier}, left, movefocus, l"
      "${modifier}, right, movefocus, r"
      "${modifier}, up, movefocus, u"
      "${modifier}, down, movefocus, d"
      "${modifier}, f, fullscreen"
      "${modifier} CTRL, SPACE, togglefloating"
      "${modifier}, down, movetoworkspace, e-1"
      "${modifier}, up, movetoworkspace, e+1"

      "${modifier}, 1, workspace, 1"
      "${modifier}, 2, workspace, 2"
      "${modifier}, 3, workspace, 3"
      "${modifier}, 4, workspace, 4"
      "${modifier}, 5, workspace, 5"
      "${modifier}, 6, workspace, 6"
      "${modifier}, 7, workspace, 7"
      "${modifier}, 8, workspace, 8"
      "${modifier}, 9, workspace, 9"
      "${modifier}, 0, workspace, 10"

      "${modifier} SHIFT, 1, movetoworkspace, 1"
      "${modifier} SHIFT, 2, movetoworkspace, 2"
      "${modifier} SHIFT, 3, movetoworkspace, 3"
      "${modifier} SHIFT, 4, movetoworkspace, 4"
      "${modifier} SHIFT, 5, movetoworkspace, 5"
      "${modifier} SHIFT, 6, movetoworkspace, 6"
      "${modifier} SHIFT, 7, movetoworkspace, 7"
      "${modifier} SHIFT, 8, movetoworkspace, 8"
      "${modifier} SHIFT, 9, movetoworkspace, 9"
      "${modifier} SHIFT, 0, movetoworkspace, 10"
    ];

    bindm = [
      "${modifier}, mouse:272, movewindow"
      "${modifier}, mouse:273, resizewindow"
    ];
  };
}
