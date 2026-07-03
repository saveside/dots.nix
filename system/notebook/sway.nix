{ pkgs, inputs, lib, ... }:

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
    gpu-screen-recorder-gtk
    librewolf
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx;
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
        common = {
          default = [ "gtk" ];
        };
        sway = {
          default = lib.mkForce [ "wlr" "gtk" ];
        };
      };
    };
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        helium
      '';
      mode = "0755";
    };
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    INTEL_DEBUG = "noccs";
    WEBRTC_USE_PIPEWIRE = "1";
    NIXOS_OZONE_WL = "1";
  };
}
