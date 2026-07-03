{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    binds.workspace_back_and_forth = true;

    bind = [
      # General
      "$mod SHIFT, r, exec, hyprctl reload"

      # User applications
      "$mod, return, exec, alacritty"
      "$mod, d, exec, equibop --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode"
      "$mod, q, exec, brave --enable-features=VaapiVideoDecodeLinuxGL,UseOzonePlatform --ozone-platform=wayland"
      "$mod, e, exec, foot yazi"
      "$mod, r, exec, vicinae toggle"
      "$mod, v, exec, code --ozone-platform=wayland"

      # Audio / Media
      "$alt, up, exec, pamixer -i 5"
      "$alt, down, exec, pamixer -d 5"
      "$mod, a, exec, bash ~/.local/bin/status"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      # SwayOSD media keys
      ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
      ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
      ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
      ", Caps_Lock, exec, swayosd-client --caps-lock"
      ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

      # Screenshot
      ", Print, exec, env XDG_CURRENT_DESKTOP=sway XDG_SESSION_DESKTOP=sway QT_QPA_PLATFORM=wayland flameshot gui"

      # Misc Utilities
      "$mod, o, exec, xset dpms force off"
      "$mod, l, exec, hyprlock"
      "$mod, b, exec, sh ~/.config/emoji/emoji.sh &"
      "$mod, n, exec, polybar-msg cmd toggle"
      "$mod, m, exec, ags -t quicksettings"
      "$mod, k, exec, swaync-client -t"

      # Window management
      "$mod, escape, workspace, previous"
      "$mod SHIFT, c, killactive"
      "$mod, right, exec, workspace next"
      "$mod, left, exec, workspace prev"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, f, fullscreen"
      "$mod CTRL, SPACE, togglefloating"
      "$mod, down, movetoworkspace, e-1"
      "$mod, up, movetoworkspace, e+1"

      # Workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Move to Workspaces
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
