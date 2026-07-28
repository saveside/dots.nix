{ ... }:

{
  programs.quickshell = {
    enable = true;
    configs.default = ./config;
    activeConfig = "default";
    systemd.enable = true;
  };
}
