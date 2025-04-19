{ config, ... }:

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
      "${modifier} SHIFT, r, exec, hyprctl reload"
      "${modifier} SHIFT, q, exec, ags -t powermenu"

      #~~~ user applications
      "${modifier}, return, exec, alacritty msg create-window"
      "${modifier}, q, exec, zen-browser"
      "${modifier}, d, exec, vesktop --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode"
      "${modifier}, e, exec, pcmanfm-qt"
      ", Print, exec, env XDG_CURRENT_DESKTOP=sway XDG_SESSION_DESKTOP=sway QT_QPA_PLATFORM=wayland flameshot gui"
      "${modifier}, r, exec, rofi -show drun"
      "${modifier}, v, exec, code --ozone-platform=wayland"

      #~~~ audio
      "${alt}, up, exec, pamixer -i 5"
      "${alt}, down, exec, pamixer -d 5"
      "${modifier}, a, exec, ${config.home.homeDirectory}/.config/hypr/scripts.d/status.sh"
      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ", XF86AudioMute, exec, pamixer -t"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      #~~~ misc utilities
      "${modifier}, o, exec, xset dpms force off"
      "${modifier}, l, exec, gtklock"
      "${modifier}, n, exec, polybar-msg cmd toggle"
      ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      "${modifier}, m, exec, ags -t quicksettings"
      "${modifier}, k, exec, swaync-client -t"

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
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
