{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    systemd = {
      enableXdgAutostart = true;
      variables = [
        "DISPLAY"
        "GNOME_KEYRING_CONTROL"
        "LD_LIBRARY_PATH"
        "NIXOS_OZONE_WL"
        "PATH"
        "SSH_AUTH_SOCK"
        "WAYLAND_DISPLAY"
        "XAUTHORITY"
        "XCURSOR_SIZE"
        "XCURSOR_THEME"
        "XDG_CURRENT_DESKTOP"
        "XDG_DATA_DIRS"
        "XDG_RUNTIME_DIR"
        "XDG_SESSION_TYPE"
      ];
    };
    settings.exec-once = [
      "${config.wrapped.ags} &"
      "${lib.getExe config.wrapped.alacritty} --daemon &"
      "${lib.getExe config.wrapped.flameshot} &"
      "${lib.getExe config.wrapped.waybar} &"
      "${lib.getExe pkgs.autotiling-rs} &"
      "${lib.getExe pkgs.networkmanagerapplet} &"
      "${lib.getExe pkgs.pcmanfm-qt} -d &"
    ];
  };
}
