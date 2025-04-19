{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "tag +notif, class:^(swaync-control-center|swaync-notification-window|swaync-client|class)$"
      "tag +terminal, class:^(Alacritty|kitty|kitty-dropterm)$"
      "tag +games, class:^(steam_app_\d+)$"
      "tag +gamestore, class:^([Ss]team)$"
      "move 0 0,class:(flameshot),title:(flameshot)"
      "pin,class:(flameshot),title:(flameshot)"
      "float,class:(flameshot),title:(flameshot)"
      "pin, title:^(Picture-in-Picture)$"
      "noblur, tag:games*"
      "fullscreen, tag:games*"
    ];

    layerrule = [
      "blur, swaync-control-center"
      "blur, swaync-notification-window"
      "animation slide, swaync-notification-window"
      "ignorezero, swaync-control-center"
      "ignorezero, swaync-notification-window"
      "ignorealpha 0.5, swaync-control-center"
      "ignorealpha 0.5, swaync-notification-window"
    ];

    windowrule = [
      "immediate, class:^(cs2)$"
    ];
  };
}
