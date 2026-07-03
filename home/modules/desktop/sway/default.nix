{ pkgs, ... }:

{
  imports = [
    ./settings.nix
    ./colors.nix
    ./keybinds.nix
    ./startup.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    extraOptions = [
      "--unsupported-gpu"
      "--my-next-gpu-wont-be-nvidia"
    ];
    checkConfig = false;
    systemd = {
      enable = true;
      variables = [
        "DISPLAY"
        "GNOME_KEYRING_CONTROL"
        "LD_LIBRARY_PATH"
        "NIXOS_OZONE_WL"
        "PATH"
        "SSH_AUTH_SOCK"
        "SWAYSOCK"
        "WAYLAND_DISPLAY"
        "XAUTHORITY"
        "XCURSOR_SIZE"
        "XCURSOR_THEME"
        "XDG_CURRENT_DESKTOP"
        "XDG_DATA_DIRS"
        "XDG_SESSION_TYPE"
      ];
      xdgAutostart = true;
    };
    extraConfig = ''
      blur enable
      blur_radius 10
      blur_passes 3
      blur_noise 0.02
      blur_saturation 1.2
      blur_contrast 1.1
      shadows disable
      corner_radius 0
      layer_effects "rofi" blur enable
      layer_effects "waybar" blur enable
      layer_effects "zen-beta" blur enable
      layer_effects "swaync" blur enable
    '';
  };
}
