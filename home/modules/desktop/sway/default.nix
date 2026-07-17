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
    package = pkgs.sway;
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
  };
}
