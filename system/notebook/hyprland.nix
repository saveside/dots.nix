# Hyprland and GUI configuration for notebook
{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    networkmanagerapplet
    gparted
    libva-utils
    lm_sensors
    v4l-utils
    vulkan-tools
    agenix-cli
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.hyprland.enable = true;
  security.pam.services.hyprlock = { };

  services.flatpak.enable = true;
  services.displayManager.ly.enable = true;

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        brave
      '';
      mode = "0755";
    };
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
  };
}
