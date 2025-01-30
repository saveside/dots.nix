{ config, pkgs, ... }:

let
  modifier = config.wayland.windowManager.sway.config.modifier;
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
      "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";

      #~~~ brightness (for Laptops)
      "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
      "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

      #~~~ playerctl
      "XF86AudioPlay" = "exec playerctl play-pause";
      "XF86AudioNext" = "exec playerctl next";
      "XF86AudioPrev" = "exec playerctl previous";

      #~~~ sway
      "${modifier}+Shift+r" = "reload";
      "${modifier}+Shift+c" = "kill";

      #~~~ other
      "${modifier}+Return" = "exec alacritty msg create-window";
      "${modifier}+d" =
        "exec vesktop --ozone-platform=wayland --disable-gpu-driver-bug-workarounds --enable-experimental-web-platform-features --new-canvas-2d-api --enable-features=VaapiVideoDecoder --enable-native-gpu-memory-buffers --canvas-oop-rasterization --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode";
      "${modifier}+l" = "exec gtklock";
      "${modifier}+Shift+q" = "exec ags -t powermenu";
      "${modifier}+q" = "exec zen-browser";
      "${modifier}+w" = "exec pcmanfm-qt";
      "${modifier}+r" = "exec rofi -show drun";
      "${modifier}+v" = "exec code";
      "${modifier}+o" = "exec xset dmps force off";
      "${modifier}+b" = "exec sh ~/.config/emoji/emoji.sh &";
      "${modifier}+n" = "exec polybar-msg cmd toggle";
      "${modifier}+k" = "exec ags -t datemenu";
      "${modifier}+m" = "exec ags -t quicksettings";
      "Print" = "exec flameshot gui -r | wl-copy";

    };
  };
}
