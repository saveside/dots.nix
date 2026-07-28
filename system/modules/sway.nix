# Sway (system + home-manager, coupled)
{ config, lib, pkgs, ... }:

let
  cfg = config.cfg.sway;
in
{
  options.cfg.sway.enable = lib.mkEnableOption "Sway window manager (system + HM)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wget
      networkmanagerapplet
      gparted
      libva-utils
      lm_sensors
      v4l-utils
      vulkan-tools
      agenix-cli
      gpu-screen-recorder-gtk
      librewolf
    ];

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      package = pkgs.swayfx;
      extraOptions = [
        "--unsupported-gpu"
        "--my-next-gpu-wont-be-nvidia"
      ];
    };

    services.displayManager.ly.enable = true;
    programs.gpu-screen-recorder.enable = true;

    xdg = {
      autostart.enable = true;
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        config = {
          common.default = [ "gtk" ];
          sway.default = lib.mkForce [
            "wlr"
            "gtk"
          ];
        };
      };
    };

    environment.etc."1password/custom_allowed_browsers" = {
      text = ''
        helium
      '';
      mode = "0755";
    };

    environment.sessionVariables = {
      EDITOR = "nvim";
      INTEL_DEBUG = "noccs";
      WEBRTC_USE_PIPEWIRE = "1";
      NIXOS_OZONE_WL = "1";
    };

    home-manager.users.savew.imports = [
      ../../home/modules/desktop/sway
      ../../home/modules/desktop/sway/quickshell
    ];
  };
}
