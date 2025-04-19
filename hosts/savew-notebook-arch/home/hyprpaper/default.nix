{ config, ... }:

{
  services.hyprpaper.settings = {
    preload = [
      config.stylix.image
    ];
    wallpaper = [
      "DP-2,${config.stylix.image}"
      "eDP-2,${config.stylix.image}"
    ];
  };
}
