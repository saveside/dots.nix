{ config, pkgs, ... }:

let
  modifier = config.wayland.windowManager.sway.config.modifier;
  alt = "Mod1";
in
{
  wayland.windowManager.sway.config.keybindings = {
    "${modifier}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
    "${modifier}+Shift+c" = "kill";
    "${modifier}+1" = "workspace number 1";
    "${modifier}+2" = "workspace number 2";
    "${modifier}+3" = "workspace number 3";
    "${modifier}+4" = "workspace number 4";
    "${modifier}+5" = "workspace number 5";
    "${modifier}+6" = "workspace number 6";
    "${modifier}+7" = "workspace number 7";
    "${modifier}+8" = "workspace number 8";
    "${modifier}+9" = "workspace number 9";
    "${modifier}+0" = "workspace number 10";
    "${modifier}+Shift+1" = "move container to workspace number 1";
    "${modifier}+Shift+2" = "move container to workspace number 2";
    "${modifier}+Shift+3" = "move container to workspace number 3";
    "${modifier}+Shift+4" = "move container to workspace number 4";
    "${modifier}+Shift+5" = "move container to workspace number 5";
    "${modifier}+Shift+6" = "move container to workspace number 6";
    "${modifier}+Shift+7" = "move container to workspace number 7";
    "${modifier}+Shift+8" = "move container to workspace number 8";
    "${modifier}+Shift+9" = "move container to workspace number 9";
    "${modifier}+Shift+0" = "move container to workspace number 0";
    "${modifier}+r" = "exec ${pkgs.rofi}/bin/rofi -show drun";
    "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui -r | wl-copy";
    "${modifier}+e" = "exec pcmanfm-qt";
    "${modifier}+Control+space" = "floating toggle";
    "${alt}+Up" = "exec \"pamixer -i 5\"";
    "${alt}+Down" = "exec \"pamixer -d 5\"";
    "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
    "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
    "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
    "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";
    "XF86AudioPlay" = "exec playerctl play-pause";
    "XF86AudioNext" = "exec playerctl next";
    "XF86AudioPrev" = "exec playerctl previous";
    "${modifier}+a" = "exec \"bash ~/.local/bin/status\"";
    "${modifier}+Escape" = "workspace back_and_forth";
    "${modifier}+Shift+r" = "reload";
    "${modifier}+f" = "fullscreen toggle";
    "${modifier}+k" = "exec swaync-client -t";
    "${modifier}+l" = "exec hyprlock";
    "${modifier}+d" = "exec equibop --ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations --enable-features=AcceleratedVideoDecodeLinuxGL --enable-features=AcceleratedVideoEncoder --enable-features=VaapiIgnoreDriverChecks --enable-features=CanvasOopRasterization --enable-gpu-rasterization --enable-zero-copy --enable-features=WebRTCPipeWireCapturer";
  };
}
