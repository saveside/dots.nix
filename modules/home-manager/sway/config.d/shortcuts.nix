{
  config,
  lib,
  pkgs,
  ...
}:

let
  modifier = config.wayland.windowManager.sway.config.modifier;
  menu = config.wayland.windowManager.sway.config.menu;
  home = config.home.homeDirectory;
in
{
  wayland.windowManager.sway.config = {
    keybindings = {
      #~~~ movement
      "${modifier}+Shift+Left" = "move left";
      "${modifier}+Shift+Down" = "move down";
      "${modifier}+Shift+Up" = "move up";
      "${modifier}+Up" = "scratchpad show, floating disable";
      "${modifier}+Left" = "workspace prev";
      "${modifier}+Right" = "workspace next";
      "${modifier}+Down" = "move scratchpad";
      "${modifier}+Escape" = "workspace back_and_forth";

      #~~~ window
      "${modifier}+f" = "fullscreen";
      "${modifier}+Control+space" = "floating toggle";
      "${modifier}+Shift+1" = "move container to workspace 1";
      "${modifier}+Shift+2" = "move container to workspace 2";
      "${modifier}+Shift+3" = "move container to workspace 3";
      "${modifier}+Shift+4" = "move container to workspace 4";
      "${modifier}+Shift+5" = "move container to workspace 5";
      "${modifier}+Shift+6" = "move container to workspace 6";
      "${modifier}+Shift+7" = "move container to workspace 7";
      "${modifier}+Shift+8" = "move container to workspace 8";
      "${modifier}+Shift+9" = "move container to workspace 9";
      "${modifier}+Shift+0" = "move container to workspace 10";

      #~~~ workspace
      "${modifier}+1" = "workspace 1";
      "${modifier}+2" = "workspace 2";
      "${modifier}+3" = "workspace 3";
      "${modifier}+4" = "workspace 4";
      "${modifier}+5" = "workspace 5";
      "${modifier}+6" = "workspace 6";
      "${modifier}+7" = "workspace 7";
      "${modifier}+8" = "workspace 8";
      "${modifier}+9" = "workspace 9";
      "${modifier}+0" = "workspace 10";

      #~~~ sound
      "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

      #~~~ brightness (for Laptops)
      "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} set +5%";
      "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} set 5%-";

      #~~~ playerctl
      "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";
      "XF86AudioPause" = "exec ${lib.getExe pkgs.playerctl} play-pause";
      "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
      "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
      "$altMod+Left" = "exec ${lib.getExe pkgs.playerctl} previous";
      "$altMod+Right" = "exec ${lib.getExe pkgs.playerctl} next";

      #~~~ sway
      "${modifier}+Shift+r" = "reload";
      "${modifier}+Shift+c" = "kill";

      #~~~ other
      "${modifier}+Return" = "exec ${lib.getExe config.wrapped.alacritty} msg create-window";
      "${modifier}+d" =
        "exec vesktop --ozone-platform=wayland --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode";
      "${modifier}+Shift+q" = "exec ${lib.getExe config.wrapped.ags} -t powermenu";
      "${modifier}+q" = "exec zen-browser";
      "${modifier}+w" = "exec ${lib.getExe pkgs.pcmanfm-qt}";
      "${modifier}+r" = "exec ${lib.getExe pkgs.rofi-wayland} -show drun";
      "${modifier}+v" = "exec code";
      "${modifier}+o" = "exec ${config.wrapped.sway}/bin/swaymsg output * dpms off";
      "${modifier}+n" = "exec ${pkgs.polybar}/bin/polybar-msg cmd toggle";
      "${modifier}+k" = "exec ${config.wrapped.ags} -t datemenu";
      "${modifier}+m" = "exec ${config.wrapped.ags} -t quicksettings";
      "Print" = "exec ${lib.getExe pkgs.flameshot} gui -r | ${pkgs.wl-clipboard}/bin/wl-copy";

    };
  };
}
