{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "blur, swaync-control-center"
      "ignorealpha 0.5, swaync-control-center"
      "blur, waybar"
      "blur, swaync-notification-window"
      "ignorealpha 0.5, swaync-notification-window"
      "blur, swayosd-client"
      "ignorealpha 0, swayosd-client"
      "blur, swayosd-server"
      "ignorealpha 0, swayosd-server"
      "blur, swayosd"
      "ignorealpha 0, swayosd"
      "xray 0, swayosd"
      "blur, vicinae"
      "ignorealpha 0, vicinae"
    ];

    windowrulev2 = [
      # Flameshot configuration
      "move 0 0, class:(flameshot), title:(flameshot)"
      "pin, class:(flameshot), title:(flameshot)"
      "float, class:(flameshot), title:(flameshot)"
      "fullscreenstate 3, class:(flameshot), title:(flameshot)"

      # SwayNC focus rules
      "noinitialfocus, class:(swaync-notification-window)"
      "nofocus, class:(swaync-notification-window)"

      # Privacy / No Screen Share
      "noscreenshare, title:(Telegram)(.*)"
      "noscreenshare, title:(.*)(All mail)(.*)"

      # Gaming / Performance
      "immediate, class:^(cs2)$"
    ];
  };
}
