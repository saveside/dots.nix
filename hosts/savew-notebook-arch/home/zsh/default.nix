{
  config,
  lib,
  pkgs,
  ...
}:

let 
  cfg = config.moduleopts.zsh;
in {
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      loginExtra = ''
        if [[ "$XDG_VTNR" == 1 && -z "$container" ]]; then
          export $(${pkgs.systemd}/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
          export GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring
          export SSH_AUTH_SOCK=$GNOME_KEYRING_CONTROL/ssh
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
          /usr/bin/Hyprland &>${config.home.homeDirectory}/.cache/hyprland.log
        fi
      '';
    };
  };
}
