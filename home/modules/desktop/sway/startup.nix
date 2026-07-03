{ pkgs, ... }:

{
  wayland.windowManager.sway.config.startup = [
    {
      command = "${pkgs.mate.mate-polkit}/usr/lib/mate-polkit/polkit-mate-authentication-agent-1";
    }
    {
      command = "exec gnome-keyring-daemon --start --components=secrets";
    }
    {
      command = "${pkgs.pcmanfm-qt}/bin/pcmanfm-qt --daemon";
    }
    {
      command = "${pkgs.swayosd}/bin/swayosd-server";
    }
    {
      command = "${pkgs.ags}/bin/ags";
    }
    {
      command = "${pkgs.autotiling-rs}/bin/autotiling-rs";
    }
    {
      command = "${pkgs.flameshot}/bin/flameshot";
    }
  ];
}
